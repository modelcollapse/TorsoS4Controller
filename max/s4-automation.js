"use strict";

// Runtime-independent CC automation. Time is in quarter-note beats, and
// track indices are zero-based. The caller resolves target IDs to MIDI CCs.
const MAX_CC = 127;

function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value));
}

function bounded(value, fallback, min, max) {
    return Number.isFinite(value) ? clamp(value, min, max) : fallback;
}

function wrap(value, length) {
    return ((value % length) + length) % length;
}

function canWrite(target) {
    return target && target.enabled !== false && Number.isInteger(target.track) &&
        target.track >= 0 && target.track < 4 && typeof target.id === "string" && target.id.length > 0;
}

function write(target, value) {
    return { track: target.track, id: target.id, value: Math.round(clamp(value, 0, MAX_CC)) };
}

function scaledTarget(target, value) {
    const min = bounded(target.min, 0, 0, MAX_CC);
    const max = bounded(target.max, MAX_CC, 0, MAX_CC);
    return write(target, min + (max - min) * clamp(value / MAX_CC, 0, 1));
}

function macroWrites(macro, value) {
    if (!macro || macro.enabled === false || !Array.isArray(macro.targets) || !Number.isFinite(value)) return [];
    return macro.targets.filter(canWrite).map(target => scaledTarget(target, value));
}

function xyWrites(xy) {
    if (!xy || xy.enabled === false || !Array.isArray(xy.targets)) return [];
    const writes = [];
    for (const target of xy.targets) {
        if (!canWrite(target) || (target.axis !== "x" && target.axis !== "y")) continue;
        const value = xy[target.axis];
        if (Number.isFinite(value)) writes.push(scaledTarget(target, value));
    }
    return writes;
}

function breakpointSegment(left, right, phase) {
    const t = clamp((phase - left.x) / (right.x - left.x), 0, 1);
    const bend = bounded(left.curve, 0, -1, 1);
    const progress = left.curve === "smooth" ? t * t * (3 - 2 * t) : t + bend * t * (1 - t);
    return left.y + (right.y - left.y) * progress;
}

function curveValue(points, timeKey, valueKey, position, maxTime, minValue, maxValue, curved = false) {
    if (!Array.isArray(points)) return undefined;
    const pointsAtTime = new Map();
    for (const point of points) {
        if (!point || !Number.isFinite(point[timeKey]) || !Number.isFinite(point[valueKey])) continue;
        const x = clamp(point[timeKey], 0, maxTime);
        pointsAtTime.set(x, { x, y: clamp(point[valueKey], minValue, maxValue), curve: curved ? point.curve : 0 });
    }
    const curve = Array.from(pointsAtTime.values()).sort((a, b) => a.x - b.x);
    if (curve.length === 0) return undefined;

    if (position <= curve[0].x) return curve[0].y;
    for (let i = 1; i < curve.length; i++) {
        if (position <= curve[i].x) return breakpointSegment(curve[i - 1], curve[i], position);
    }
    return curve[curve.length - 1].y;
}

function shapeValue(shape, phase, unwrappedPhase, breakpoints) {
    const turn = 2 * Math.PI * phase;
    switch (shape) {
    case "tri":
    case "triangle":
        return 1 - 4 * Math.abs(phase - 0.5);
    case "saw":
        return 2 * phase - 1;
    case "ramp":
        return 1 - 2 * phase;
    case "square":
        return phase < 0.5 ? 1 : -1;
    case "smooth":
        return 0.55 * Math.sin(turn) + 0.25 * Math.sin(2 * turn) + 0.20 * Math.sin(3 * turn);
    case "sh":
        return 2 * ((Math.floor(phase * 16) * 73 + 19) % 127) / 126 - 1;
    case "random": {
        // Repeatable sample and hold, with a fresh pattern on each cycle.
        const bucket = Math.floor(unwrappedPhase * 16);
        const sample = Math.sin(bucket * 12.9898 + 78.233) * 43758.5453;
        return 2 * (sample - Math.floor(sample)) - 1;
    }
    case "exp":
    case "log": {
        const firstHalf = phase < 0.5;
        const magnitude = firstHalf ? phase * 2 : (1 - phase) * 2;
        const shaped = shape === "exp" ? Math.pow(magnitude, 2.4) : Math.log10(1 + 9 * magnitude);
        return firstHalf ? shaped : -shaped;
    }
    case "bp":
    case "breakpoint":
        return curveValue(breakpoints, "x", "y", phase, 1, -1, 1, true) ?? 0;
    default:
        return Math.sin(turn);
    }
}

function periodInBeats(lfo) {
    if (Number.isFinite(lfo.period) && lfo.period > 0) return lfo.period;
    if (!Number.isFinite(lfo.rate)) return 1;
    // The Swift sync clock advances LFOs 16 times per quarter note.
    const exponent = 1 - clamp(lfo.rate, 0, MAX_CC) / MAX_CC;
    return Math.max(1, 0.25 * Math.pow(128, exponent)) / 16;
}

function lfoWrites(lfos, beat) {
    if (!Array.isArray(lfos) || !Number.isFinite(beat) || beat < 0) return [];
    const writes = [];
    for (const lfo of lfos) {
        if (!canWrite(lfo) || !lfo.enabled || lfo.run === false) continue;
        const cycles = beat / periodInBeats(lfo);
        if (!Number.isFinite(cycles)) continue;
        const offset = wrap(bounded(lfo.phase, 0, 0, 1), 1);
        const direction = String(lfo.direction || "fwd").toLowerCase();
        let unwrappedPhase = cycles + offset;
        let phase = wrap(unwrappedPhase, 1);
        if (direction === "rev" || direction === "reverse") {
            unwrappedPhase = offset - cycles;
            phase = wrap(unwrappedPhase, 1);
        } else if (direction === "pp" || direction === "p-p" || direction === "pingpong") {
            const reflected = 1 - Math.abs(wrap(cycles, 2) - 1);
            phase = wrap(reflected + offset, 1);
        }
        const shape = String(lfo.shape || lfo.waveform || "sine").toLowerCase();
        const sample = shapeValue(shape, phase, unwrappedPhase, lfo.breakpoints);
        const center = bounded(lfo.center, 64, 0, MAX_CC);
        const depth = bounded(lfo.depth, 64, 0, MAX_CC);
        writes.push(write(lfo, center + sample * depth * 0.5));
    }
    return writes;
}

function songWrites(song, beat) {
    if (!song || !song.enabled || !Array.isArray(song.lanes) || !Number.isFinite(beat) || beat < 0) return [];
    const length = song.length;
    if (!Number.isFinite(length) || length <= 0 || (song.loop === false && beat > length)) return [];

    const loop = song.loop !== false;
    const direction = String(song.direction || "fwd").toLowerCase();
    let position = loop ? wrap(beat, length) : beat;
    if (direction === "rev" || direction === "reverse") {
        position = length - position;
    } else if (direction === "pp" || direction === "p-p" || direction === "pingpong") {
        position = length - Math.abs(wrap(beat, length * 2) - length);
    }

    const writes = [];
    for (const lane of song.lanes) {
        if (!canWrite(lane) || lane.muted) continue;
        const value = curveValue(lane.points, "beat", "value", position, length, 0, MAX_CC);
        if (value !== undefined) writes.push(write(lane, value));
    }
    return writes;
}

module.exports = { macroWrites, xyWrites, lfoWrites, songWrites, breakpointSegment };
