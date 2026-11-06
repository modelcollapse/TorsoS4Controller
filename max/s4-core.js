"use strict";

const { parameters, parametersById, defaultLaneIds } = require("./s4-parameters");
const { macroWrites, lfoWrites, songWrites, xyWrites } = require("./s4-automation");

const TRACKS = 4;
const SLOTS = 8;
const MAX_STEPS = 64;
const MAX_BREAKPOINTS = 64;
const BREAKPOINT_RESOLUTION = 1000;
const RATE_CHOICES = [0.0625, 0.125, 0.25, 0.333333, 0.5, 0.75, 1, 2, 4];
const DIRECTIONS = ["forward", "reverse", "pingpong"];
const SHAPES = ["sine", "triangle", "saw", "square", "random", "ramp", "smooth", "exp", "log", "breakpoint"];
const PROJECT_FORMAT = "torso-s4-max";
const PROJECT_VERSION = 1;

function inRange(value, fallback, min, max, round = false) {
    if (typeof value !== "number" || !Number.isFinite(value)) return fallback;
    const bounded = Math.max(min, Math.min(max, value));
    return round ? Math.round(bounded) : bounded;
}

function index(value, count) {
    return Number.isInteger(value) && value >= 0 && value < count;
}

function flag(value, fallback = false) {
    if (value === true || value === 1) return true;
    if (value === false || value === 0) return false;
    return fallback;
}

function parameter(id) {
    return typeof id === "string" && Object.prototype.hasOwnProperty.call(parametersById, id)
        ? parametersById[id]
        : null;
}

function trackNumber(value, fallback = 0) {
    return index(value, TRACKS) ? value : fallback;
}

function ccValue(value, fallback = 0) {
    return inRange(value, fallback, 0, 127, true);
}

function config(value) {
    return value && typeof value === "object" && !Array.isArray(value) ? value : {};
}

function slots(value) {
    return Array.isArray(value) ? value : [];
}

function oneOf(value, choices, fallback) {
    return choices.includes(value) ? value : fallback;
}

function roundBreakpoint(value) {
    return Math.round(value * BREAKPOINT_RESOLUTION) / BREAKPOINT_RESOLUTION;
}

function breakpointCurve(value) {
    return value === "smooth" ? value : roundBreakpoint(inRange(value, 0, -1, 1));
}

function breakpointData(source) {
    const points = new Map([[0, { x: 0, y: 0, curve: 0 }], [1, { x: 1, y: 0, curve: 0 }]]);
    for (const point of slots(source)) {
        if (!point || !Number.isFinite(point.x) || point.x < 0 || point.x > 1 || !Number.isFinite(point.y)) continue;
        const x = roundBreakpoint(point.x);
        if (points.has(x) || points.size < MAX_BREAKPOINTS) {
            points.set(x, {
                x,
                y: roundBreakpoint(inRange(point.y, 0, -1, 1)),
                curve: breakpointCurve(point.curve ?? points.get(x)?.curve)
            });
        }
    }
    return Array.from(points.values()).sort((a, b) => a.x - b.x);
}

const defaultId = parameters.find(item => item.scope === "track").id;
const laneIds = defaultLaneIds.length ? defaultLaneIds : [defaultId];

function targetData(value, fallback, axis = false) {
    value = config(value);
    if (!parameter(value.id)) return fallback;
    const target = {
        track: trackNumber(value.track),
        id: value.id,
        min: ccValue(value.min),
        max: ccValue(value.max, 127)
    };
    if (axis) target.axis = value.axis === "y" ? "y" : "x";
    return target;
}

function defaultXYTargets() {
    return ["mix_t1_level", "mix_t2_level"].map((id, i) => parameter(id)
        ? { track: i, id, axis: i === 0 ? "x" : "y", min: 0, max: 127 }
        : null);
}

function projectData(source) {
    source = config(source);
    const tracks = Array.from({ length: TRACKS }, (_, i) => i);
    const indices = Array.from({ length: SLOTS }, (_, i) => i);
    const rawSong = config(source.song);
    const rawXY = config(source.xy);
    const songLength = inRange(rawSong.length, 16, 1, 256, true);
    return {
        track: trackNumber(source.track),
        channels: tracks.map(i => inRange(slots(source.channels)[i], i + 1, 1, 16, true)),
        selected: tracks.map(i => parameter(slots(source.selected)[i]) ? source.selected[i] : defaultId),
        values: tracks.map(i => {
            const values = config(slots(source.values)[i]);
            return Object.fromEntries(parameters
                .filter(item => typeof values[item.id] === "number" && Number.isFinite(values[item.id]))
                .map(item => [item.id, ccValue(values[item.id])]));
        }),
        lanes: indices.map(i => {
            const lane = config(slots(source.lanes)[i]);
            const steps = slots(lane.steps);
            return {
                track: trackNumber(lane.track, i % TRACKS),
                id: parameter(lane.id) ? lane.id : laneIds[i % laneIds.length],
                enabled: flag(lane.enabled, i < TRACKS),
                muted: flag(lane.muted),
                length: inRange(lane.length, 16, 1, MAX_STEPS, true),
                rate: inRange(lane.rate, 0.25, RATE_CHOICES[0], 16),
                direction: oneOf(lane.direction, DIRECTIONS, "forward"),
                steps: Array.from({ length: MAX_STEPS }, (_, n) => steps[n] == null || steps[n] < 0 ? null : ccValue(steps[n])),
                playhead: -1
            };
        }),
        macros: indices.map(i => {
            const macro = config(slots(source.macros)[i]);
            const hardwareId = "perform_macro" + (i + 1);
            const fallback = parameter(hardwareId) ? { track: 0, id: hardwareId, min: 0, max: 127 } : null;
            return {
                name: typeof macro.name === "string" ? macro.name.slice(0, 32) : "Macro " + (i + 1),
                value: ccValue(macro.value),
                targets: Array.from({ length: 4 }, (_, target) =>
                    targetData(slots(macro.targets)[target], !Array.isArray(macro.targets) && target === 0 ? fallback : null))
            };
        }),
        lfos: indices.map(i => {
            const lfo = config(slots(source.lfos)[i]);
            return {
                track: trackNumber(lfo.track, i % TRACKS),
                id: parameter(lfo.id) ? lfo.id : laneIds[i % laneIds.length],
                enabled: flag(lfo.enabled),
                shape: oneOf(lfo.shape, SHAPES, "sine"),
                period: inRange(lfo.period, 4, 0.0625, 256),
                center: ccValue(lfo.center, 64),
                depth: ccValue(lfo.depth, 32),
                phase: inRange(lfo.phase, 0, 0, 1),
                breakpoints: breakpointData(lfo.breakpoints)
            };
        }),
        song: {
            enabled: flag(rawSong.enabled),
            length: songLength,
            lanes: indices.map(i => {
                const lane = config(slots(rawSong.lanes)[i]);
                const points = new Map();
                for (const point of slots(lane.points).slice(0, 1024)) {
                    if (point && Number.isFinite(point.beat) && point.beat >= 0 && point.beat <= songLength &&
                            Number.isFinite(point.value)) points.set(point.beat, ccValue(point.value));
                }
                return {
                    track: trackNumber(lane.track, i % TRACKS),
                    id: parameter(lane.id) ? lane.id : laneIds[i % laneIds.length],
                    enabled: flag(lane.enabled, i < TRACKS),
                    points: Array.from(points, ([beat, value]) => ({ beat, value })).sort((a, b) => a.beat - b.beat)
                };
            })
        },
        xy: {
            x: ccValue(rawXY.x, 64),
            y: ccValue(rawXY.y, 64),
            targets: Array.from({ length: 4 }, (_, i) =>
                targetData(slots(rawXY.targets)[i], Array.isArray(rawXY.targets) ? null : defaultXYTargets()[i] ?? null, true))
        },
        bpm: inRange(source.bpm, 120, 20, 300)
    };
}

function stepAt(ordinal, length, direction) {
    if (length <= 1) return 0;
    if (direction === "reverse") return length - 1 - (ordinal % length);
    if (direction === "pingpong") {
        const span = length * 2 - 2;
        const phase = ordinal % span;
        return phase < length ? phase : span - phase;
    }
    return ordinal % length;
}

class Controller {
    constructor() {
        this.project = projectData();
        this.playing = false;
        this.beat = 0;
        this.lastTime = null;
        this.lastFrame = -Infinity;
        this.lastAutomationBeat = -Infinity;
        this.ordinals = Array(SLOTS).fill(-1);
        this.lastSent = new Map();
        this.pending = [];
    }

    snapshot() {
        return { ...this.project, playing: this.playing, beat: this.beat };
    }

    serialize() {
        return JSON.stringify({ format: PROJECT_FORMAT, version: PROJECT_VERSION, project: this.project }, (key, value) =>
            key === "playhead" ? undefined : value, 2);
    }

    restore(text) {
        const data = JSON.parse(text);
        if (!data || data.format !== PROJECT_FORMAT || data.version !== PROJECT_VERSION ||
                !data.project || typeof data.project !== "object" || Array.isArray(data.project)) {
            throw new Error("Choose a Torso S4 Max project saved by this patch.");
        }
        const next = projectData(data.project);
        this.stop();
        this.project = next;
        this.lastSent.clear();
    }

    resetDestination() {
        this.lastSent.clear();
        this.lastAutomationBeat = -Infinity;
    }

    takeMidi() {
        return this.pending.splice(0);
    }

    writeMany(writes, force = false) {
        const byAddress = new Map();
        for (const { track, id, value } of writes) {
            if (!index(track, TRACKS) || !parameter(id) || !Number.isFinite(value)) continue;
            const item = parameter(id);
            const channel = item.scope === "global" ? item.channel : this.project.channels[track];
            const status = 0xb0 + channel - 1;
            byAddress.set(status * 128 + item.cc, { status, item, track, value: ccValue(value) });
        }
        for (const [key, entry] of byAddress) {
            const { status, item, track, value } = entry;
            if (item.scope === "global") {
                for (const values of this.project.values) values[item.id] = value;
            } else {
                this.project.values[track][item.id] = value;
            }
            if (force || this.lastSent.get(key) !== value) {
                this.pending.push([status, item.cc, value]);
                this.lastSent.set(key, value);
            }
        }
    }

    start() {
        if (this.playing) return;
        this.playing = true;
        this.beat = 0;
        this.lastAutomationBeat = -Infinity;
        this.ordinals.fill(-1);
        this.renderBeat();
    }

    stop() {
        this.playing = false;
        this.beat = 0;
        this.ordinals.fill(-1);
        for (const lane of this.project.lanes) lane.playhead = -1;
    }

    tick(now) {
        if (!Number.isFinite(now)) return false;
        const elapsed = this.lastTime === null ? 0 : Math.max(0, now - this.lastTime);
        this.lastTime = now;
        if (!this.playing) return false;
        this.beat += elapsed * this.project.bpm / 60000;
        this.renderBeat();
        if (now - this.lastFrame < 65) return false;
        this.lastFrame = now;
        return true;
    }

    renderBeat() {
        const writes = [];
        const { song, lfos, lanes, bpm } = this.project;
        // Update continuous sources at about 50 Hz; sequencer edges use every clock tick.
        if ((this.beat - this.lastAutomationBeat) * 60000 / bpm >= 19) {
            writes.push(...lfoWrites(lfos, this.beat), ...songWrites(song, this.beat));
            this.lastAutomationBeat = this.beat;
        }
        for (let slot = 0; slot < lanes.length; slot++) {
            const lane = lanes[slot];
            if (!lane.enabled) {
                lane.playhead = -1;
                this.ordinals[slot] = -1;
                continue;
            }
            const ordinal = Math.floor((this.beat + 1e-9) / lane.rate);
            const changed = ordinal !== this.ordinals[slot];
            this.ordinals[slot] = ordinal;
            const step = stepAt(ordinal, lane.length, lane.direction);
            lane.playhead = step;
            if (changed && !lane.muted && lane.steps[step] !== null) {
                writes.push({ track: lane.track, id: lane.id, value: lane.steps[step] });
            }
        }
        this.writeMany(writes);
    }

    command(name, args) {
        const [a, b, c, d, e, f] = args;
        const p = this.project;
        switch (name) {
            case "play": if (flag(a, true)) this.start(); else this.stop(); break;
            case "stop": this.stop(); break;
            case "bpm": p.bpm = inRange(a, p.bpm, 20, 300); break;
            case "track": p.track = trackNumber(a, p.track); break;
            case "channel":
                if (index(a, TRACKS)) p.channels[a] = inRange(b, p.channels[a], 1, 16, true);
                this.resetDestination();
                break;
            case "select":
                if (index(a, TRACKS) && parameter(b)) p.selected[a] = b;
                break;
            case "control": this.writeMany([{ track: a, id: b, value: c }], true); break;
            case "lane":
                if (index(a, SLOTS)) this.editLane(p.lanes[a], b, c);
                break;
            case "step":
                if (index(a, SLOTS) && index(b, MAX_STEPS) && Number.isFinite(c)) {
                    p.lanes[a].steps[b] = c < 0 ? null : ccValue(c);
                }
                break;
            case "macro":
                if (index(a, SLOTS) && Number.isFinite(b)) {
                    const macro = p.macros[a];
                    macro.value = ccValue(b);
                    this.writeMany(macroWrites(macro, macro.value), true);
                }
                break;
            case "macrotarget":
                if (index(a, SLOTS) && index(b, 4)) {
                    p.macros[a].targets[b] = d === "none" ? null : targetData({ track: c, id: d, min: e, max: f }, p.macros[a].targets[b]);
                }
                break;
            case "lfo":
                if (index(a, SLOTS)) this.editLfo(p.lfos[a], b, c);
                break;
            case "lfopoint":
                if (index(a, SLOTS)) this.editLfoPoint(p.lfos[a], b, c, d);
                break;
            case "lfocurve":
                if (index(a, SLOTS)) this.editLfoCurve(p.lfos[a], b, c);
                break;
            case "song": this.editSong(a, b); break;
            case "songlane":
                if (index(a, SLOTS)) this.editTargetLane(p.song.lanes[a], b, c);
                break;
            case "songpoint":
                if (index(a, SLOTS) && Number.isFinite(b) && Number.isFinite(c)) this.editSongPoint(p.song.lanes[a], b, c);
                break;
            case "xy":
                if (Number.isFinite(a) && Number.isFinite(b)) {
                    p.xy.x = ccValue(a);
                    p.xy.y = ccValue(b);
                    this.writeMany(xyWrites(p.xy), true);
                }
                break;
            case "xytarget":
                if (index(a, 4)) {
                    p.xy.targets[a] = c === "none" ? null : targetData({ track: b, id: c, axis: d, min: e, max: f }, p.xy.targets[a], true);
                }
                break;
            default: return false;
        }
        return true;
    }

    editTargetLane(lane, field, value) {
        if (field === "id" && parameter(value)) lane.id = value;
        if (field === "track") lane.track = trackNumber(value, lane.track);
        if (field === "enabled") lane.enabled = flag(value, lane.enabled);
    }

    editLane(lane, field, value) {
        this.editTargetLane(lane, field, value);
        if (field === "muted") lane.muted = flag(value, lane.muted);
        if (field === "length") lane.length = inRange(value, lane.length, 1, MAX_STEPS, true);
        if (field === "rate") lane.rate = inRange(value, lane.rate, RATE_CHOICES[0], 16);
        if (field === "direction") lane.direction = oneOf(value, DIRECTIONS, lane.direction);
    }

    editLfo(lfo, field, value) {
        this.editTargetLane(lfo, field, value);
        if (field === "shape") lfo.shape = oneOf(value, SHAPES, lfo.shape);
        if (field === "period") lfo.period = inRange(value, lfo.period, 0.0625, 256);
        if (field === "center" || field === "depth") lfo[field] = ccValue(value, lfo[field]);
        if (field === "phase") lfo.phase = inRange(value, lfo.phase, 0, 1);
    }

    editLfoPoint(lfo, oldX, newX, value) {
        if (!Number.isFinite(oldX) || !Number.isFinite(newX)) return;
        const points = lfo.breakpoints;
        if (oldX === -1) {
            if (newX < 0 || newX > 1 || !Number.isFinite(value)) return;
            lfo.breakpoints = breakpointData([...points, { x: newX, y: value }]);
            return;
        }

        const i = points.findIndex(point => point.x === roundBreakpoint(oldX));
        if (i < 0) return;
        const endpoint = i === 0 || i === points.length - 1;
        if (newX === -1) {
            if (!endpoint) points.splice(i, 1);
            return;
        }

        if (!Number.isFinite(value)) return;
        const x = endpoint ? points[i].x : roundBreakpoint(inRange(
            newX, points[i].x, points[i - 1].x + 1 / BREAKPOINT_RESOLUTION, points[i + 1].x - 1 / BREAKPOINT_RESOLUTION));
        points[i] = { ...points[i], x, y: roundBreakpoint(inRange(value, 0, -1, 1)) };
    }

    editLfoCurve(lfo, pointX, curve) {
        if (!Number.isFinite(pointX) || (curve !== "smooth" && !Number.isFinite(curve))) return;
        const x = roundBreakpoint(pointX);
        const point = lfo.breakpoints.find(item => item.x === x && x < 1);
        if (point) point.curve = breakpointCurve(curve);
    }

    editSong(field, value) {
        const song = this.project.song;
        if (field === "enabled") song.enabled = flag(value, song.enabled);
        if (field === "length") {
            song.length = inRange(value, song.length, 1, 256, true);
            for (const lane of song.lanes) lane.points = lane.points.filter(point => point.beat <= song.length);
        }
    }

    editSongPoint(lane, beat, value) {
        const position = Math.round(Math.max(0, Math.min(this.project.song.length, beat)) * 1000) / 1000;
        const found = lane.points.findIndex(point => point.beat === position);
        if (found >= 0) lane.points.splice(found, 1);
        if (value >= 0 && lane.points.length < 1024) {
            lane.points.push({ beat: position, value: ccValue(value) });
            lane.points.sort((a, b) => a.beat - b.beat);
        }
    }
}

exports.Controller = Controller;
exports.stepAt = stepAt;
