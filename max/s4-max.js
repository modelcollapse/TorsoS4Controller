// Max adapter. UI and MIDI ports are connected by the patcher.
inlets = 1;
outlets = 4;

const { Controller } = require("./s4-core");
const engine = new Controller();
const viewState = new Dict();
const NO_OUTPUT = "No MIDI output";
let port = NO_OUTPUT;

function loadbang() {
    announce();
    publish();
    showStatus("Choose a MIDI output");
}

function announce() {
    const project = engine.snapshot();
    outlet(2, "bpm", project.bpm);
    outlet(2, "playing", Number(project.playing));
}
announce.local = 1;

function publish() {
    viewState.parse(JSON.stringify(engine.snapshot()));
    outlet(1, "dictionary", viewState.name);
}
publish.local = 1;

function showStatus(message) {
    outlet(2, "status", message);
}
showStatus.local = 1;

function flush() {
    for (const bytes of engine.takeMidi()) outlet(0, bytes);
}
flush.local = 1;

function destination() {
    const name = arrayfromargs(arguments).join(" ").trim();
    port = name || NO_OUTPUT;
    outlet(3, "port", port === NO_OUTPUT ? "none" : port);
    engine.resetDestination();
    showStatus(port === NO_OUTPUT ? "Choose a MIDI output" : "MIDI out: " + port);
}

function tick(ms) {
    const frame = engine.tick(ms);
    flush();
    if (frame) publish();
}

function saveproject(path) {
    if (typeof path !== "string" || !path.length) return;
    if (!path.toLowerCase().endsWith(".json")) path += ".json";
    try {
        const file = new File(path, "write");
        if (!file.isopen) throw new Error("Could not open the project file for writing.");
        try {
            file.eof = 0;
            for (const line of engine.serialize().split("\n")) file.writeline(line);
        } finally {
            file.close();
        }
        showStatus("Saved " + path.split("/").pop());
    } catch (err) {
        showStatus(err.message);
    }
}

function openproject(path) {
    if (typeof path !== "string" || !path.length) return;
    try {
        const file = new File(path, "read");
        if (!file.isopen) throw new Error("Could not open the project file.");
        let text = "";
        try {
            if (file.eof > 2 * 1024 * 1024) throw new Error("Project file is too large.");
            while (file.position < file.eof) {
                const before = file.position;
                text += file.readstring(Math.min(file.eof - before, 4096));
                if (file.position <= before) throw new Error("Could not read the entire project file.");
            }
        } finally {
            file.close();
        }
        engine.restore(text);
        announce();
        publish();
        showStatus("Opened " + path.split("/").pop());
    } catch (err) {
        showStatus(err.message);
    }
}

function anything() {
    const name = messagename;
    const args = arrayfromargs(arguments);
    if (!engine.command(name, args)) return;
    flush();
    if (name === "play" || name === "stop" || name === "bpm") announce();
    publish();
}
