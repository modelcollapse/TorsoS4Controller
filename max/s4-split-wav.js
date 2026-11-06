"use strict";

const fs = require("node:fs/promises");
const path = require("node:path");

const PAIRS = 5;
const SAMPLE_BYTES = 3;
const STEM_FRAME_BYTES = 2 * SAMPLE_BYTES;
const SOURCE_FRAME_BYTES = PAIRS * STEM_FRAME_BYTES;
const CHUNK_FRAMES = 32768;
const PCM_SUBTYPE = Buffer.from("0100000000001000800000aa00389b71", "hex");

async function readFull(file, buffer, count, position) {
    let offset = 0;
    while (offset < count) {
        const { bytesRead } = await file.read(buffer, offset, count - offset, position + offset);
        if (!bytesRead) throw new Error("The interleaved WAV ended unexpectedly.");
        offset += bytesRead;
    }
}

async function writeFull(file, buffer, count, position) {
    let offset = 0;
    while (offset < count) {
        const { bytesWritten } = await file.write(buffer, offset, count - offset, position + offset);
        if (!bytesWritten) throw new Error("Writing the stereo WAV made no progress.");
        offset += bytesWritten;
    }
}

function sampleRate(fmt) {
    const type = fmt.readUInt16LE(0);
    const isExtensiblePCM = type === 0xfffe && fmt.length >= 40 &&
        fmt.readUInt16LE(16) >= 22 && fmt.readUInt16LE(18) === 24 && fmt.subarray(24, 40).equals(PCM_SUBTYPE);
    const rate = fmt.readUInt32LE(4);
    if ((type !== 1 && !isExtensiblePCM) || fmt.readUInt16LE(2) !== 10 ||
        fmt.readUInt16LE(12) !== SOURCE_FRAME_BYTES || fmt.readUInt16LE(14) !== 24 ||
        !rate || fmt.readUInt32LE(8) !== rate * SOURCE_FRAME_BYTES) {
        throw new Error("Expected a ten-channel, 24-bit PCM WAV from Max.");
    }
    return rate;
}

async function sourceInfo(file, size) {
    const header = Buffer.alloc(12);
    await readFull(file, header, header.length, 0);
    if (header.toString("ascii", 0, 4) !== "RIFF" || header.toString("ascii", 8, 12) !== "WAVE") {
        throw new Error("Expected a RIFF/WAVE recording from Max.");
    }
    if (header.readUInt32LE(4) + 8 !== size) throw new Error("The interleaved WAV is incomplete or still open.");

    const chunkHeader = Buffer.alloc(8);
    let rate, dataOffset, dataBytes;
    for (let offset = 12; offset + chunkHeader.length <= size;) {
        await readFull(file, chunkHeader, chunkHeader.length, offset);
        const type = chunkHeader.toString("ascii", 0, 4);
        const length = chunkHeader.readUInt32LE(4);
        const payload = offset + chunkHeader.length;
        const next = payload + length + length % 2;
        if (next > size) throw new Error("The interleaved WAV has an incomplete chunk.");
        if (type === "fmt " && length >= 16 && rate === undefined) {
            const format = Buffer.alloc(Math.min(length, 40));
            await readFull(file, format, format.length, payload);
            rate = sampleRate(format);
        } else if (type === "data" && dataOffset === undefined) {
            dataOffset = payload;
            dataBytes = length;
        }
        if (rate !== undefined && dataOffset !== undefined) break;
        offset = next;
    }
    if (!rate || !dataBytes || dataBytes % SOURCE_FRAME_BYTES) {
        throw new Error("The interleaved WAV has no complete audio frames.");
    }
    return { rate, dataOffset, frames: dataBytes / SOURCE_FRAME_BYTES };
}

function stereoHeader(frames, rate) {
    const bytes = frames * STEM_FRAME_BYTES;
    const header = Buffer.alloc(44);
    header.write("RIFF", 0);
    header.writeUInt32LE(36 + bytes, 4);
    header.write("WAVEfmt ", 8);
    header.writeUInt32LE(16, 16);
    header.writeUInt16LE(1, 20);
    header.writeUInt16LE(2, 22);
    header.writeUInt32LE(rate, 24);
    header.writeUInt32LE(rate * STEM_FRAME_BYTES, 28);
    header.writeUInt16LE(STEM_FRAME_BYTES, 32);
    header.writeUInt16LE(24, 34);
    header.write("data", 36);
    header.writeUInt32LE(bytes, 40);
    return header;
}

function takePaths(source, stems) {
    if (stems.length !== PAIRS || [source, ...stems].some(file => typeof file !== "string" || !path.isAbsolute(file))) {
        throw new Error("Expected an absolute recording path and five absolute stem paths.");
    }
    const files = [source, ...stems].map(file => path.normalize(file));
    const folder = path.dirname(files[0]);
    if (files.some(file => path.dirname(file) !== folder) || new Set(files).size !== files.length) {
        throw new Error("The recording and stems must have distinct names in the same folder.");
    }
    return files;
}

async function removeIfOwned(file, identity) {
    const actual = await fs.lstat(file).catch(error => {
        if (error.code !== "ENOENT") throw error;
    });
    if (!actual) return;
    if (!identity || actual.dev !== identity.dev || actual.ino !== identity.ino) {
        throw new Error("A recording file was replaced while splitting: " + path.basename(file));
    }
    await fs.unlink(file);
}

async function writeAudio(source, stems, info) {
    const header = stereoHeader(info.frames, info.rate);
    for (const stem of stems) await writeFull(stem.handle, header, header.length, 0);
    const interleaved = Buffer.allocUnsafe(CHUNK_FRAMES * SOURCE_FRAME_BYTES);
    const stereo = Buffer.allocUnsafe(CHUNK_FRAMES * STEM_FRAME_BYTES);
    for (let base = 0; base < info.frames; base += CHUNK_FRAMES) {
        const frames = Math.min(CHUNK_FRAMES, info.frames - base);
        await readFull(source, interleaved, frames * SOURCE_FRAME_BYTES, info.dataOffset + base * SOURCE_FRAME_BYTES);
        for (let pair = 0; pair < stems.length; pair++) {
            let input = pair * STEM_FRAME_BYTES;
            let output = 0;
            for (let frame = 0; frame < frames; frame++) {
                for (let byte = 0; byte < STEM_FRAME_BYTES; byte++) stereo[output++] = interleaved[input + byte];
                input += SOURCE_FRAME_BYTES;
            }
            await writeFull(stems[pair].handle, stereo, frames * STEM_FRAME_BYTES, header.length + base * STEM_FRAME_BYTES);
        }
    }
}

async function closeEntry(entry) {
    if (!entry?.handle) return;
    const file = entry.handle;
    entry.handle = null;
    await file.close();
}

async function splitWav(sourcePath, ...stemPaths) {
    const [sourceName, ...stemNames] = takePaths(sourcePath, stemPaths);
    const stems = [];
    let source;
    try {
        const sourceLink = await fs.lstat(sourceName);
        if (!sourceLink.isFile()) throw new Error("The interleaved recording must be a regular WAV file.");
        source = { handle: await fs.open(sourceName, "r") };
        const identity = await source.handle.stat();
        if (sourceLink.dev !== identity.dev || sourceLink.ino !== identity.ino) {
            throw new Error("The interleaved recording was replaced before splitting.");
        }
        const info = await sourceInfo(source.handle, identity.size);
        for (const file of stemNames) {
            const stem = { file, handle: await fs.open(file, "wx") };
            stems.push(stem);
            stem.identity = await stem.handle.stat();
        }
        await writeAudio(source.handle, stems, info);
        for (const stem of stems) {
            await stem.handle.sync();
            await closeEntry(stem);
        }
        const written = await source.handle.stat();
        if (written.size !== identity.size || written.mtimeMs !== identity.mtimeMs) {
            throw new Error("The interleaved recording changed while splitting.");
        }
        await closeEntry(source);
        await removeIfOwned(sourceName, identity);
        return { frames: info.frames, rate: info.rate };
    } catch (error) {
        await Promise.allSettled([source, ...stems].map(closeEntry));
        const cleanup = await Promise.allSettled(stems.map(stem => removeIfOwned(stem.file, stem.identity)));
        if (cleanup.some(result => result.status === "rejected")) {
            throw new Error(error.message + " Some partial stem files could not be removed.");
        }
        throw error;
    }
}

let maxApi;
try {
    maxApi = require("max-api");
} catch (error) {
    // Allow the splitter to run without Max in a Node verification process.
    if (error.code !== "MODULE_NOT_FOUND" || !error.message.includes("'max-api'")) throw error;
}
if (maxApi) {
    maxApi.addHandler("split", async (...args) => {
        try {
            const result = await splitWav(...args);
            maxApi.outlet("splitdone", result.frames, result.rate);
        } catch (error) {
            maxApi.outlet("spliterror", error.message);
        }
    });
}

module.exports = { splitWav };
