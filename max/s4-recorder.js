// One native 10-channel capture gives every stereo pair the same sample clock.
// Outlet 0 controls sfrecord~, 1 requests the split, 2–3 update the UI.
inlets = 1;
outlets = 4;

const stems = ['Main', 'Track-1', 'Track-2', 'Track-3', 'Track-4'];
let directory = '';
let filePrefix = 'S4';
let audioOn = false;
let inputCount = 0;
let take = null;

const status = message => outlet(2, 'set', message);
const idleStatus = () => {
    if (!directory) status('Choose a destination folder.');
    else if (!audioOn) status('Turn on audio in Max Audio Status.');
    else if (inputCount < 10) status(`Max sees ${inputCount} inputs. Select S-4 as the audio input.`);
    else status(`Ready to record five stereo files. Max sees ${inputCount} inputs.`);
};

function init() {
    if (max.os === 'windows') this.patcher.getnamed('absolute_folder').message('pathtype', 'absolute');
    if (!take) idleStatus();
}

function folder() {
    if (take) return;
    let path = Array.from(arguments).join(' ');
    if (max.os === 'windows') {
        path = path.replace(/\\/g, '/');
        if (!/^(?:[A-Za-z]:\/|\/\/[^/]+\/[^/]+)/.test(path)) path = '';
    } else if (!path.startsWith('/')) {
        // Boot-relative conversion leaves Max's Volume:/path form on other disks.
        const volumePath = path.match(/^([^/:]+):\/(.*)$/);
        path = volumePath ? `/Volumes/${volumePath[1]}/${volumePath[2]}` : '';
    }
    if (!path) {
        status('Could not read this folder path. Choose another destination.');
        return;
    }
    directory = path.replace(/\/+$/, '') || '/';
    if (max.os === 'windows' && /^[A-Za-z]:$/.test(directory)) directory += '/';
    outlet(3, 'set', directory);
    idleStatus();
}

function prefix() {
    if (take) return;
    filePrefix = Array.from(arguments).join(' ').trim().replace(/[^a-zA-Z0-9_-]+/g, '-')
        .replace(/^[-_]+|[-_]+$/g, '').slice(0, 60) || 'S4';
}

function dsp(on) {
    const wasOn = audioOn;
    audioOn = Number(on) === 1;
    if (wasOn && !audioOn && take && take.recording) endTake('Audio turned off. ');
    else if (!take) idleStatus();
}

function inputs(count) {
    inputCount = Math.max(0, Number(count) || 0);
    if (!take) idleStatus();
}

const folderNames = path => {
    const listing = new Folder(path);
    try {
        if (listing.count < 0) return null;
        const names = new Set();
        while (!listing.end) {
            names.add(String(listing.filename).toLowerCase());
            listing.next();
        }
        return names;
    } finally {
        listing.close();
    }
};

const timeStamp = date => {
    const pad = (value, size = 2) => String(value).padStart(size, '0');
    const day = `${date.getFullYear()}${pad(date.getMonth() + 1)}${pad(date.getDate())}`;
    const clock = `${pad(date.getHours())}${pad(date.getMinutes())}${pad(date.getSeconds())}`;
    return `${day}-${clock}-${pad(date.getMilliseconds(), 3)}`;
};

function start() {
    if (take) return;
    if (!directory || !audioOn || inputCount < 10) {
        idleStatus();
        return;
    }

    const existing = folderNames(directory);
    if (!existing) {
        status('Could not read the destination. Choose another folder.');
        return;
    }
    const nonce = Math.floor(Math.random() * 1679616).toString(36).padStart(4, '0');
    const name = `${filePrefix}-${timeStamp(new Date())}-${nonce}`;
    const names = stems.map(stem => `${name}-${stem}.wav`);
    const sourceName = `${name}-10ch-source.wav`;
    if ([sourceName, ...names].some(filename => existing.has(filename.toLowerCase()))) {
        status('A file with this take name exists. Click Record to choose a new name.');
        return;
    }

    const base = directory.replace(/\/+$/, '');
    take = {
        name,
        source: `${base}/${sourceName}`,
        sourceName,
        files: names.map(filename => `${base}/${filename}`),
        recording: true,
        started: false,
        splitting: false
    };
    outlet(0, 'samptype', 'int24');
    outlet(0, 'open', take.source);
    status('Opening the ten-channel capture…');
    startTask.schedule(150);
}

const startTask = new Task(() => {
    if (!take || !take.recording) return;
    take.started = true;
    outlet(0, 1);
    status(`RECORDING  ·  ${take.name}`);
}, this);

const u16 = (bytes, offset) => bytes[offset] + bytes[offset + 1] * 256;
const u32 = (bytes, offset) => u16(bytes, offset) + u16(bytes, offset + 2) * 65536;
const tag = (bytes, offset) => String.fromCharCode(...bytes.slice(offset, offset + 4));

const hasCompleteCapture = path => {
    const file = new File(path, 'read');
    if (!file.isopen) return false;
    try {
        const size = file.eof;
        const header = file.readbytes(12);
        if (header.length < 12 || tag(header, 0) !== 'RIFF' || tag(header, 8) !== 'WAVE') return false;
        const end = u32(header, 4) + 8;
        if (end > size) return false;

        while (file.position + 8 <= end) {
            const chunk = file.readbytes(8);
            if (chunk.length < 8) return false;
            const length = u32(chunk, 4);
            const payload = file.position;
            if (length > end - payload) return false;
            if (tag(chunk, 0) === 'data') return length > 0;
            file.position = payload + length + (length % 2);
        }
        return false;
    } finally {
        file.close();
    }
};

const checkTake = () => {
    if (!take || take.recording || take.splitting) return;
    if (!hasCompleteCapture(take.source)) {
        if (take.attempts++ < 7) {
            checkTask.schedule(300);
            return;
        }
        status(`${take.stopMessage}Capture missing or incomplete. Check ${take.sourceName} in the destination.`);
        take = null;
        return;
    }
    take.splitting = true;
    status(`${take.stopMessage}Writing five aligned stereo WAVs…`);
    outlet(1, 'split', take.source, ...take.files);
};

const checkTask = new Task(checkTake, this);

function endTake(message) {
    if (!take || !take.recording) return;
    startTask.cancel();
    outlet(0, 0);
    if (!take.started) {
        status(`${message}Recording cancelled before capture started.`);
        take = null;
        return;
    }
    take.recording = false;
    take.stopMessage = message;
    take.attempts = 0;
    status(`${message}Finishing the ten-channel capture…`);
    checkTask.schedule(450);
}
endTake.local = 1;

function stop() {
    endTake('');
}

function splitdone(frames, rate) {
    if (!take || !take.splitting) return;
    const seconds = (Number(frames) / Number(rate)).toFixed(1);
    status(`Saved five stereo WAVs  ·  ${seconds} s  ·  ${take.name}`);
    take = null;
}

function spliterror() {
    if (!take || !take.splitting) return;
    const error = Array.from(arguments).join(' ');
    status(`Split failed. Capture kept as ${take.sourceName}. ${error}`);
    take = null;
}
