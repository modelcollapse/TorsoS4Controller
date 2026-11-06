// Torso S-4 Max controller. This canvas translates pointer actions into messages.
// The controller owns all MIDI routing, transport, and saved project state.
"use strict";

inlets = 1;
outlets = 1;
autowatch = 1;
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

const map = require("./s4-parameters");
const { lfoWrites, breakpointSegment } = require("./s4-automation");
const parameters = map.parameters;
const parameterById = new Map(parameters.map((parameter) => [parameter.id, parameter]));
const groups = [...new Set(parameters.map((parameter) => parameter.group))];
const width = 1020;
const height = 590;
const colors = {
    bg: "#101419", panel: "#181f27", raised: "#202a34", edge: "#303b47",
    text: "#f0f3f3", secondary: "#acb9c4", muted: "#8998a5", accent: "#86e0c2",
    accentInk: "#12251f", accentDim: "#25433c", gold: "#f1c47c", off: "#495866",
    danger: "#f4a6a6", shade: "#090d11"
};
const trackColors = ["#86e0c2", "#8ec4f8", "#f1c47c", "#e8a9d8"];
const tabs = ["Control", "Sequencer", "Macros", "LFOs", "Song", "Performance"];
let tab = "Control";
let group = groups[0];
let controlPage = 0;
let laneIndex = 0;
let sequencePage = 0;
let macroIndex = 0;
let lfoIndex = 0;
let breakpointRequestSlot = -1;
const selectedBreakpoints = new Map();
let songLaneIndex = 0;
let songPointIndex = 0;
let picker = null;
let hitRegions = [];
let activeGesture = null;
let stateData = {};
let statusText = "";
let waveCache = { key: null, samples: [] };
let viewport = [width, height];
const colorCache = new Map();

function color(hex, opacity) {
    if (!colorCache.has(hex)) {
        colorCache.set(hex, [1, 3, 5].map((start) => parseInt(hex.slice(start, start + 2), 16) / 255));
    }
    const rgb = colorCache.get(hex);
    mgraphics.set_source_rgba(rgb[0], rgb[1], rgb[2], opacity === undefined ? 1 : opacity);
}

function rect(x, y, w, h, fill, opacity) {
    color(fill, opacity);
    mgraphics.rectangle(x, y, w, h);
    mgraphics.fill();
}

function round(x, y, w, h, radius, fill, stroke) {
    mgraphics.rectangle_rounded(x, y, w, h, radius, radius);
    color(fill);
    if (stroke) {
        mgraphics.fill_preserve();
        mgraphics.set_line_width(1);
        color(stroke);
        mgraphics.stroke();
    } else {
        mgraphics.fill();
    }
}

function line(x1, y1, x2, y2, stroke, lineWidth) {
    color(stroke);
    mgraphics.set_line_width(lineWidth || 1);
    mgraphics.move_to(x1, y1);
    mgraphics.line_to(x2, y2);
    mgraphics.stroke();
}

function textAt(value, x, y, options = {}) {
    mgraphics.select_font_face("Arial", "normal", options.bold ? "bold" : "normal");
    mgraphics.set_font_size(options.size || 13);
    color(options.color || colors.text);
    let label = String(value);
    if (options.max && mgraphics.text_measure(label)[0] > options.max) {
        while (label.length && mgraphics.text_measure(label + "…")[0] > options.max) label = label.slice(0, -1);
        label += "…";
    }
    if (options.align === "right") x -= mgraphics.text_measure(label)[0];
    if (options.align === "center") x -= mgraphics.text_measure(label)[0] / 2;
    mgraphics.move_to(x, y);
    mgraphics.show_text(label);
}

function section(title, description) {
    textAt(title, 24, 120, { size: 23, bold: true });
    textAt(description, 24, 143, { size: 13, color: colors.secondary });
}

function hit(x, y, w, h, action, gesture) {
    hitRegions.push({ x, y, w, h, action, gesture });
}

function button(x, y, w, h, label, action, options = {}) {
    const fill = options.active ? (options.accent || colors.accent) : colors.raised;
    round(x, y, w, h, options.radius || 7, fill, options.active ? null : colors.edge);
    textAt(label, x + w / 2, y + h / 2 + 4.5, {
        size: options.size || 13, bold: !!options.active, align: "center",
        color: options.active ? colors.accentInk : (options.color || colors.text), max: w - 12
    });
    if (action) hit(x, y, w, h, action);
}

function controlLabel(label, x, y) {
    textAt(label, x, y, { size: 11, bold: true, color: colors.secondary });
}

function choose(x, y, w, h, label, title, options, value, action, groupId) {
    round(x, y, w, h, 7, colors.raised, colors.edge);
    textAt(label, x + 11, y + h / 2 + 4, { size: 13, max: w - 32 });
    textAt("▾", x + w - 12, y + h / 2 + 4, { align: "right", color: colors.secondary });
    hit(x, y, w, h, () => {
        const visible = groupId ? options.filter((item) => item.group === groupId) : options;
        const selected = visible.findIndex((item) => item.value === value);
        picker = { title, options, page: Math.floor(Math.max(0, selected) / 32), value, action, groupId };
    });
}

function clamp(n, min, max) {
    return Math.max(min, Math.min(max, n));
}

function quantize(n, min, max, step) {
    const rounded = min + Math.round((clamp(n, min, max) - min) / step) * step;
    return Number(clamp(rounded, min, max).toFixed(6));
}

function slider(x, y, w, h, value, min, max, step, action, accent = colors.accent) {
    const amount = clamp((Number(value) - min) / (max - min), 0, 1);
    round(x, y + (h - 5) / 2, w, 5, 2.5, colors.off);
    if (amount > 0) round(x, y + (h - 5) / 2, Math.max(5, w * amount), 5, 2.5, accent);
    round(x + amount * w - 5, y + (h - 13) / 2, 10, 13, 4, accent);
    const move = (mouseX) => action(quantize(min + (max - min) * (mouseX - x) / w, min, max, step));
    hit(x - 5, y - 3, w + 10, h + 6, move, move);
}

function stepper(x, y, w, label, value, adjust, delta = 1) {
    controlLabel(label, x, y);
    button(x, y + 8, 26, 30, "−", () => adjust(-delta));
    round(x + 29, y + 8, w - 58, 30, 6, colors.panel, colors.edge);
    textAt(value, x + w / 2, y + 28, { align: "center", size: 12, bold: true, max: w - 63 });
    button(x + w - 26, y + 8, 26, 30, "+", () => adjust(delta));
}

function emit(selector, ...args) {
    outlet(0, [selector, ...args]);
}

function state(json) {
    try {
        msg_dictionary(JSON.parse(String(json)));
    } catch (error) {
        statusText = "The controller state could not be read.";
        mgraphics.redraw();
    }
}

function dictionary(name) {
    state(new Dict(name).stringify());
}

function msg_dictionary(value) {
    if (value && typeof value === "object") stateData = value;
    mgraphics.redraw();
}

function status(...parts) {
    statusText = parts.join(" ");
    mgraphics.redraw();
}

function selectTab(name) {
    tab = name;
    picker = null;
    activeGesture = null;
}

function header() {
    rect(0, 0, width, height, colors.bg);
    rect(0, 0, width, 4, colors.accent);
    textAt("S‑4", 24, 42, { size: 29, bold: true });
    textAt("TORSO CONTROLLER", 92, 38, { size: 12, bold: true, color: colors.secondary });
    textAt(statusText || "MIDI CONTROL & AUTOMATION", 995, 36, { size: 11, color: colors.muted, align: "right", max: 420 });
    let x = 24;
    for (const label of tabs) {
        const w = label.length * 7.5 + 28;
        button(x, 54, w, 32, label, () => selectTab(label), { active: label === tab });
        x += w + 7;
    }
    line(24, 96, 996, 96, colors.edge);
}

function footer(message) {
    line(24, 554, 996, 554, colors.edge);
    textAt(message, 24, 576, { size: 12, color: colors.secondary, max: 830 });
    textAt("TORSO S‑4  /  MAX", 995, 576, { size: 11, color: colors.muted, align: "right" });
}

function drawPicker() {
    const { options, page, title, value, action, groupId } = picker;
    hitRegions = [];
    rect(0, 0, width, height, colors.shade, 0.86);
    hit(0, 0, width, height, () => { picker = null; });
    const x = 78, y = groupId ? 48 : 76, w = 864, h = groupId ? 497 : 437;
    round(x, y, w, h, 13, colors.panel, colors.edge);
    hit(x, y, w, h, () => {});
    textAt(title, x + 21, y + 33, { size: 20, bold: true });
    button(x + w - 82, y + 13, 62, 29, "Close", () => { picker = null; });
    if (groupId) {
        groups.forEach((id, i) => {
            const gx = x + 20 + (i % 7) * 118, gy = y + 48 + Math.floor(i / 7) * 31;
            button(gx, gy, 111, 26, map.groups[id] || id, () => {
                picker.groupId = id;
                picker.page = 0;
            }, { active: groupId === id, size: 12 });
        });
    }
    const visible = groupId ? options.filter((item) => item.group === groupId) : options;
    const pageCount = Math.max(1, Math.ceil(visible.length / 32));
    const start = page * 32;
    visible.slice(start, start + 32).forEach((option, i) => {
        const col = Math.floor(i / 8), row = i % 8;
        const bx = x + 20 + col * 207, by = y + (groupId ? 120 : 58) + row * 39;
        button(bx, by, 199, 34, option.label, () => {
            picker = null;
            action(option.value);
        }, { active: option.value === value, size: 12 });
    });
    if (pageCount > 1) {
        button(x + 20, y + h - 46, 90, 30, "Previous", () => { picker.page = Math.max(0, page - 1); });
        button(x + 117, y + h - 46, 90, 30, "Next", () => { picker.page = Math.min(pageCount - 1, page + 1); });
        textAt("Page " + (page + 1) + " / " + pageCount, x + 221, y + h - 26, { color: colors.secondary, size: 12 });
    }
}

const allParameterOptions = parameters.map((parameter) => ({
    label: parameter.label,
    value: parameter.id,
    group: parameter.group
}));

function parameterLabel(id) {
    const parameter = parameterById.get(id);
    return parameter ? parameter.label : "Choose parameter";
}

function pickParameter(x, y, w, h, id, action) {
    const parameter = parameterById.get(id);
    const label = parameter ? parameter.label : "Choose parameter";
    choose(x, y, w, h, label, "Choose an S‑4 parameter", allParameterOptions, id, action, parameter ? parameter.group : group);
}

function trackOptions() {
    return [0, 1, 2, 3].map((track) => ({ value: track, label: "Track " + (track + 1) }));
}

function pickTrack(x, y, w, h, track, action) {
    choose(x, y, w, h, "Track " + (track + 1), "Choose a target track", trackOptions(), track, action);
}

function pickEnum(x, y, w, h, title, choices, value, action) {
    const options = choices.map((choice) => typeof choice === "object" ? choice : { label: String(choice), value: choice });
    const selected = options.find((option) => option.value === value);
    choose(x, y, w, h, selected ? selected.label : String(value), title, options, value, action);
}

function pickChannel(x, y, w, h, channel, action) {
    const channels = Array.from({ length: 16 }, (_, i) => ({ label: "Ch " + (i + 1), value: i + 1 }));
    pickEnum(x, y, w, h, "MIDI channel", channels, channel, action);
}

function trackAccent(track) {
    return trackColors[track] || colors.accent;
}

function pointer(x, y) {
    return [x * width / viewport[0], y * height / viewport[1]];
}

function onclick(x, y) {
    [x, y] = pointer(x, y);
    for (let i = hitRegions.length - 1; i >= 0; i--) {
        const region = hitRegions[i];
        if (x >= region.x && y >= region.y && x <= region.x + region.w && y <= region.y + region.h) {
            activeGesture = region.gesture || null;
            region.action(x, y);
            mgraphics.redraw();
            return;
        }
    }
    activeGesture = null;
}

function ondrag(x, y, down) {
    if (down && activeGesture) {
        activeGesture(...pointer(x, y));
        mgraphics.redraw();
    } else if (!down) {
        activeGesture = null;
    }
}

function drawControls() {
    section("Track controls", "Choose a track and parameter group. Moving a slider sends its MIDI CC value.");
    const track = clamp(Number(stateData.track) || 0, 0, 3);
    const channels = stateData.channels || [1, 2, 3, 4];
    for (let i = 0; i < 4; i++) {
        button(24 + i * 98, 160, 90, 33, "Track " + (i + 1), () => emit("track", i), {
            active: i === track, accent: trackAccent(i)
        });
    }
    controlLabel("MIDI CHANNEL", 424, 152);
    pickChannel(424, 160, 84, 33, channels[track], (channel) => emit("channel", track, channel));
    controlLabel("PARAMETER GROUP", 532, 152);
    const groupOptions = groups.map((name) => ({ value: name, label: map.groups[name] || name }));
    choose(532, 160, 210, 33, map.groups[group] || group, "Choose a parameter group", groupOptions, group, (name) => {
        group = name;
        controlPage = 0;
    });

    const groupParameters = parameters.filter((parameter) => parameter.group === group);
    const pageSize = 16;
    const pageCount = Math.max(1, Math.ceil(groupParameters.length / pageSize));
    if (pageCount > 1) {
        button(766, 160, 34, 33, "‹", () => { controlPage = Math.max(0, controlPage - 1); });
        textAt((controlPage + 1) + " / " + pageCount, 838, 181, { align: "center", color: colors.secondary });
        button(875, 160, 34, 33, "›", () => { controlPage = Math.min(pageCount - 1, controlPage + 1); });
    }
    const values = (stateData.values || [])[track] || {};
    const selected = (stateData.selected || [])[track];
    groupParameters.slice(controlPage * pageSize, (controlPage + 1) * pageSize).forEach((parameter, i) => {
        const x = 24 + (i % 4) * 245, y = 210 + Math.floor(i / 4) * 82;
        const value = values[parameter.id];
        const accent = parameter.scope === "global" ? colors.gold : trackAccent(track);
        round(x, y, 237, 73, 8, colors.panel, selected === parameter.id ? accent : colors.edge);
        hit(x, y, 237, 31, () => emit("select", track, parameter.id));
        textAt(parameter.label, x + 12, y + 20, { bold: true, size: 13, max: 176 });
        textAt(value === undefined ? "—" : value, x + 222, y + 20, { bold: true, align: "right", color: accent });
        slider(x + 15, y + 27, 205, 24, value === undefined ? 64 : value, 0, 127, 1, (next) => {
            if ((stateData.selected || [])[track] !== parameter.id) emit("select", track, parameter.id);
            emit("control", track, parameter.id, next);
        }, accent);
        const channel = parameter.scope === "global" ? parameter.channel : channels[track];
        textAt("CC " + parameter.cc + "  ·  Ch " + channel, x + 12, y + 63, { size: 10, color: colors.secondary });
    });
    footer("Unsent values show —. Global parameters use their assigned S‑4 channel.");
}

function slotList(slots, selected, select, describe, isEnabled, title) {
    controlLabel(title, 24, 173);
    slots.forEach((slot, i) => {
        const y = 184 + i * 43;
        const active = i === selected;
        const accent = trackAccent(slot.track);
        round(24, y, 199, 37, 7, active ? colors.accentDim : colors.panel, active ? accent : colors.edge);
        round(34, y + 13, 11, 11, 5, isEnabled(slot) ? accent : colors.off);
        textAt(String(i + 1).padStart(2, "0"), 53, y + 23, { size: 11, color: colors.secondary });
        textAt(describe(slot, i), 77, y + 23, { size: 13, bold: active, max: 136 });
        hit(24, y, 199, 37, () => select(i));
    });
}

function emptyView(title, detail) {
    section(title, detail);
    textAt("Waiting for the controller…", 24, 184, { color: colors.secondary });
    footer("The patch will populate these controls when it loads.");
}

function drawSequencer() {
    const lanes = stateData.lanes || [];
    if (!lanes.length) return emptyView("CC sequencer", "Set up automation lanes for any S‑4 parameter.");
    section("CC sequencer", "Edit a lane, then draw MIDI values into the steps. Each lane runs at its own rate.");
    laneIndex = clamp(laneIndex, 0, lanes.length - 1);
    const lane = lanes[laneIndex];
    const accent = trackAccent(lane.track);
    const set = (field, value) => emit("lane", laneIndex, field, value);
    slotList(lanes, laneIndex, (index) => { laneIndex = index; sequencePage = 0; },
        (slot) => "T" + (slot.track + 1) + " · " + parameterLabel(slot.id), (slot) => slot.enabled && !slot.muted, "AUTOMATION LANES");

    controlLabel("TARGET TRACK", 246, 173);
    pickTrack(246, 184, 103, 32, lane.track, (next) => set("track", next));
    controlLabel("PARAMETER", 362, 173);
    pickParameter(362, 184, 271, 32, lane.id, (next) => set("id", next));
    controlLabel("DIRECTION", 646, 173);
    pickEnum(646, 184, 133, 32, "Lane direction", [
        { label: "Forward", value: "forward" },
        { label: "Reverse", value: "reverse" },
        { label: "Ping-pong", value: "pingpong" }
    ], lane.direction, (next) => set("direction", next));
    button(792, 184, 91, 32, lane.enabled ? "Enabled" : "Disabled", () => set("enabled", lane.enabled ? 0 : 1), { active: lane.enabled });
    button(896, 184, 99, 32, lane.muted ? "Muted" : "Unmuted", () => set("muted", lane.muted ? 0 : 1), { active: lane.muted, accent: colors.gold });

    stepper(246, 242, 109, "STEPS", lane.length, (delta) => set("length", clamp(lane.length + delta, 1, 64)));
    controlLabel("BEATS PER STEP", 371, 242);
    const rateChoices = [
        { label: "1/64 note", value: 0.0625 }, { label: "1/32 note", value: 0.125 },
        { label: "1/16 note", value: 0.25 }, { label: "1/8 triplet", value: 1 / 3 },
        { label: "1/8 note", value: 0.5 }, { label: "Dotted 1/8 note", value: 0.75 },
        { label: "1/4 note", value: 1 }, { label: "1/2 note", value: 2 }, { label: "1 bar (4 beats)", value: 4 }
    ];
    pickEnum(371, 250, 142, 30, "Beats per step", rateChoices, lane.rate, (next) => set("rate", next));

    const pageCount = Math.max(1, Math.ceil(lane.length / 16));
    sequencePage = clamp(sequencePage, 0, pageCount - 1);
    const start = sequencePage * 16;
    button(821, 250, 33, 30, "‹", () => { sequencePage = Math.max(0, sequencePage - 1); });
    textAt("Steps " + (start + 1) + "–" + Math.min(start + 16, lane.length), 910, 269, { align: "center", color: colors.secondary, size: 12 });
    button(962, 250, 33, 30, "›", () => { sequencePage = Math.min(pageCount - 1, sequencePage + 1); });

    for (let i = 0; i < 16; i++) {
        const step = start + i, x = 246 + i * 47;
        const available = step < lane.length;
        const value = lane.steps[step];
        const current = step === lane.playhead;
        const hasValue = value !== null && value !== undefined && value >= 0;
        const left = x + 2, top = 320, cellW = 41, cellH = 158;
        textAt(step + 1, x + 22, 310, { size: 11, align: "center", color: current ? accent : colors.secondary, bold: current });
        round(left, top, cellW, cellH, 6, available ? colors.panel : colors.bg, current ? accent : colors.edge);
        if (available && hasValue) {
            const barH = Math.max(3, 140 * value / 127);
            round(left + 6, top + cellH - 7 - barH, cellW - 12, barH, 3, current ? accent : colors.accentDim);
        }
        if (available) {
            const update = (_mouseX, mouseY) => emit("step", laneIndex, step, Math.round(127 * clamp(1 - (mouseY - top) / cellH, 0, 1)));
            hit(left, top, cellW, cellH, update, update);
            textAt(hasValue ? value : "—", x + 22, 496, { size: 11, align: "center", color: hasValue ? colors.text : colors.muted });
            button(left + 6, 506, 29, 24, "×", () => emit("step", laneIndex, step, -1), { color: colors.secondary });
        }
    }
    footer("Drag a bar to set its value. × leaves the step empty.");
}

function drawMacros() {
    const macros = stateData.macros || [];
    if (!macros.length) return emptyView("Macros", "Drive several S‑4 parameters from one control.");
    section("Macros", "Each macro fans out to four targets. Set the minimum and maximum for each target.");
    macroIndex = clamp(macroIndex, 0, macros.length - 1);
    const macro = macros[macroIndex];
    slotList(macros, macroIndex, (i) => { macroIndex = i; },
        (slot, i) => slot.name || "Macro " + (i + 1), (slot) => (slot.targets || []).some((target) => target && target.id), "MACRO SLOTS");
    controlLabel("MACRO VALUE", 246, 173);
    textAt(macro.value, 994, 173, { align: "right", bold: true, color: colors.accent });
    slider(255, 184, 729, 29, macro.value, 0, 127, 1, (value) => emit("macro", macroIndex, value));
    controlLabel("TRACK", 254, 238);
    controlLabel("PARAMETER", 373, 238);
    controlLabel("LOW", 684, 238);
    controlLabel("HIGH", 794, 238);
    for (let i = 0; i < 4; i++) {
        const target = activeTarget(macro.targets, i);
        const y = 249 + i * 62;
        const track = target ? target.track : (stateData.track || 0);
        const id = target ? target.id : "";
        const min = target ? target.min : 0;
        const max = target ? target.max : 127;
        const set = (nextTrack, nextId, nextMin, nextMax) => emit("macrotarget", macroIndex, i, nextTrack, nextId, nextMin, nextMax);
        round(246, y, 749, 52, 7, colors.panel, colors.edge);
        if (target) pickTrack(254, y + 10, 108, 32, track, (value) => set(value, id, min, max));
        pickParameter(373, y + 10, 289, 32, id, (value) => set(track, value, min, max));
        if (target) {
            textAt(min, 684, y + 21, { size: 11, color: colors.secondary });
            slider(689, y + 26, 77, 18, min, 0, 127, 1, (value) => set(track, id, value, max));
            textAt(max, 794, y + 21, { size: 11, color: colors.secondary });
            slider(799, y + 26, 77, 18, max, 0, 127, 1, (value) => set(track, id, min, value));
            button(909, y + 10, 76, 32, "Remove", () => set(track, "none", min, max), { size: 12 });
        }
    }
    footer("Move the macro slider to send. Set the low value above the high value to invert a target.");
}

function rangeEditor(x, y, w, label, value, min, max, step, action, accent) {
    controlLabel(label, x, y);
    textAt(value, x + w, y, { align: "right", color: accent || colors.accent, size: 12, bold: true });
    slider(x + 5, y + 8, w - 10, 28, value, min, max, step, action, accent);
}

function activeTarget(targets, index) {
    const target = (targets || [])[index];
    return target && parameterById.has(target.id) ? target : null;
}

function drawLFOs() {
    const lfos = stateData.lfos || [];
    if (!lfos.length) {
        section("LFOs", "Waiting for the LFO controls. Reopen this Max patch if they do not appear.");
        footer("Keep the patch and its companion scripts in the same folder.");
        return;
    }
    section("LFOs", "Set the target, waveform and timing. Enabled LFOs run while the transport plays.");
    lfoIndex = clamp(lfoIndex, 0, lfos.length - 1);
    const lfo = lfos[lfoIndex];
    const accent = trackAccent(lfo.track);
    const set = (field, value) => emit("lfo", lfoIndex, field, value);
    const setShape = (value) => {
        breakpointRequestSlot = value === "breakpoint" && lfo.shape !== value ? lfoIndex : -1;
        set("shape", value);
    };
    if (lfo.shape === "breakpoint" && breakpointRequestSlot === lfoIndex) breakpointRequestSlot = -1;
    slotList(lfos, lfoIndex, (i) => { lfoIndex = i; breakpointRequestSlot = -1; },
        (slot) => "T" + (slot.track + 1) + " · " + parameterLabel(slot.id), (slot) => slot.enabled, "LFO SLOTS");
    controlLabel("TARGET TRACK", 246, 173);
    pickTrack(246, 184, 112, 32, lfo.track, (value) => set("track", value));
    controlLabel("PARAMETER", 371, 173);
    pickParameter(371, 184, 283, 32, lfo.id, (value) => set("id", value));
    controlLabel("WAVEFORM", 668, 173);
    pickEnum(668, 184, 121, 32, "LFO waveform", [
        { value: "sine", label: "Sine" }, { value: "triangle", label: "Triangle" },
        { value: "saw", label: "Saw" }, { value: "square", label: "Square" },
        { value: "random", label: "Random hold" }, { value: "ramp", label: "Ramp down" },
        { value: "smooth", label: "Smooth" }, { value: "exp", label: "Exponential" },
        { value: "log", label: "Logarithmic" }, { value: "breakpoint", label: "Breakpoint" }
    ], lfo.shape, setShape);
    button(798, 184, 108, 32, "Breakpoint", () => setShape("breakpoint"), { active: lfo.shape === "breakpoint" });
    button(914, 184, 81, 32, lfo.enabled ? "Enabled" : "Disabled", () => set("enabled", lfo.enabled ? 0 : 1), { active: lfo.enabled });
    round(246, 237, 749, 288, 8, colors.panel, colors.edge);

    const periods = [0.0625, 0.125, 0.25, 0.5, 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 128, 256];
    const periodOptions = periods.map((value) => ({ value, label: value + (value === 1 ? " beat" : " beats") }));
    controlLabel("PERIOD", 264, 263);
    pickEnum(264, 272, 184, 32, "Beats per LFO cycle", periodOptions, lfo.period, (value) => set("period", value));
    rangeEditor(264, 338, 185, "CENTER", lfo.center, 0, 127, 1, (value) => set("center", value), accent);
    rangeEditor(264, 403, 185, "DEPTH", lfo.depth, 0, 127, 1, (value) => set("depth", value), accent);
    rangeEditor(264, 468, 185, "PHASE", lfo.phase, 0, 1, 0.01, (value) => set("phase", value), accent);
    if (lfo.shape === "breakpoint") {
        drawBreakpointEditor(478, 259, 498, 246, lfo, accent);
        footer(lfo.breakpoints && lfo.breakpoints.length >= 64
            ? "64-point limit reached. Remove a point to add another. Curve bends the selected point’s outgoing line."
            : "Click to add, drag to move, and use Curve to bend the line after the selected point.");
    } else {
        drawWaveform(478, 259, 498, 246, lfo, accent);
        footer(breakpointRequestSlot === lfoIndex
            ? "If Breakpoint stays unavailable, reopen the updated Max patch and its companion scripts."
            : "Click Breakpoint to draw a waveform. Center and depth are MIDI values.");
    }
}

function drawBreakpointEditor(x, y, w, h, lfo, accent) {
    round(x, y, w, h, 7, colors.bg, colors.edge);
    const slot = lfoIndex;
    const points = lfo.breakpoints;
    if (!Array.isArray(points) || points.length < 2) {
        textAt("Reopen the updated patch to load the Breakpoint editor.", x + 18, y + 32, { color: colors.secondary });
        return;
    }
    const selected = points.find((point) => point.x === selectedBreakpoints.get(slot)) || points[0];
    const selectedX = selected.x;
    const gx = x + 32, gy = y + 19, gw = w - 50, gh = h - 70;
    const xFor = (phase) => gx + gw * phase;
    const yFor = (amplitude) => gy + gh * (1 - amplitude) / 2;
    const phaseFor = (px) => quantize((px - gx) / gw, 0, 1, 0.001);
    const amplitudeFor = (py) => quantize(1 - (py - gy) / gh * 2, -1, 1, 0.001);

    for (let i = 0; i <= 8; i++) line(xFor(i / 8), gy, xFor(i / 8), gy + gh, colors.edge);
    for (const amplitude of [-1, -0.5, 0, 0.5, 1]) {
        const yy = yFor(amplitude);
        line(gx, yy, gx + gw, yy, amplitude === 0 ? colors.off : colors.edge);
        if (Number.isInteger(amplitude)) textAt(amplitude > 0 ? "+1" : amplitude, gx - 7, yy + 4,
            { align: "right", size: 10, color: colors.secondary });
    }
    for (let i = 1; i < points.length; i++) {
        const previous = points[i - 1], current = points[i];
        const selected = previous.x === selectedX;
        const resolution = typeof breakpointSegment === "function" && previous.curve
            ? Math.max(2, Math.min(36, Math.ceil((current.x - previous.x) * gw / 5))) : 1;
        color(selected ? colors.gold : accent);
        mgraphics.set_line_width(selected ? 2.5 : 2);
        mgraphics.move_to(xFor(previous.x), yFor(previous.y));
        for (let j = 1; j <= resolution; j++) {
            const phase = previous.x + (current.x - previous.x) * j / resolution;
            const level = j === resolution ? current.y : breakpointSegment(previous, current, phase);
            mgraphics.line_to(xFor(phase), yFor(level));
        }
        mgraphics.stroke();
    }
    if (stateData.playing && lfo.enabled) {
        const phase = (stateData.beat / lfo.period + lfo.phase) % 1;
        line(xFor(phase), gy, xFor(phase), gy + gh, colors.gold);
    }

    let drag;
    const beginDrag = (phase, amplitude, previous, next) => {
        const endpoint = phase === 0 || phase === 1;
        const min = endpoint ? phase : Number((previous.x + 0.001).toFixed(3));
        const max = endpoint ? phase : Number((next.x - 0.001).toFixed(3));
        drag = { phase, amplitude, min, max };
        selectedBreakpoints.set(slot, phase);
    };
    const move = (px, py) => {
        if (!drag) return;
        const phase = clamp(phaseFor(px), drag.min, drag.max);
        const amplitude = amplitudeFor(py);
        if (drag.phase === phase && drag.amplitude === amplitude) return;
        const previous = drag.phase;
        drag.phase = phase;
        drag.amplitude = amplitude;
        selectedBreakpoints.set(slot, phase);
        emit("lfopoint", slot, previous, phase, amplitude);
    };
    hit(gx, gy, gw, gh, (px, py) => {
        const phase = phaseFor(px), amplitude = amplitudeFor(py);
        const index = points.findIndex((point) => point.x >= phase);
        const occupied = points[index] && points[index].x === phase;
        if (!occupied && points.length >= 64) return;
        beginDrag(phase, amplitude, points[index - 1], points[index + (occupied ? 1 : 0)]);
        emit("lfopoint", slot, occupied ? phase : -1, phase, amplitude);
    }, move);

    points.forEach((point, index) => {
        const xx = xFor(point.x), yy = yFor(point.y);
        const endpoint = point.x === 0 || point.x === 1;
        const selected = point.x === selectedX;
        round(xx - 5, yy - 5, 10, 10, endpoint ? 2 : 5, selected ? colors.gold : accent, colors.bg);
        hit(xx - 9, yy - 9, 18, 18,
            () => beginDrag(point.x, point.y, points[index - 1], points[index + 1]), move);
    });

    const baseline = y + h - 14;
    const label = "Phase " + (selected.x * 100).toFixed(1) + "%   ·   Level " + selected.y.toFixed(2);
    textAt(label, gx, baseline, { size: 11, color: colors.secondary, max: 147 });
    if (selected.x < 1) {
        const smooth = selected.curve === "smooth";
        const bend = Number.isFinite(selected.curve) ? selected.curve : 0;
        if (typeof breakpointSegment === "function" && (smooth || Number.isFinite(selected.curve))) {
            const setCurve = (value) => emit("lfocurve", slot, selected.x, value);
            controlLabel("CURVE TO NEXT", 661, baseline - 14);
            const amount = bend > 0 ? "+" + bend.toFixed(2) : bend.toFixed(2);
            if (!smooth && bend !== 0) textAt(amount, 781, baseline - 14,
                { size: 11, align: "right", color: colors.gold });
            slider(665, baseline - 10, 110, 17, bend, -1, 1, 0.01, setCurve, colors.gold);
            button(786, baseline - 18, 52, 25, "Linear", () => setCurve(0), { active: !smooth && bend === 0, size: 11 });
            button(843, baseline - 18, 60, 25, "Smooth", () => setCurve("smooth"), { active: smooth, size: 11 });
        } else {
            textAt("Reopen patch to load Curve", 661, baseline, { size: 11, color: colors.secondary, max: 174 });
        }
    }
    if (selected.x > 0 && selected.x < 1) {
        button(909, baseline - 18, 55, 25, "Remove", () => {
            selectedBreakpoints.delete(slot);
            emit("lfopoint", slot, selected.x, -1, selected.y);
        }, { size: 11 });
    }
}

function waveformSamples(lfo) {
    const key = [lfo.shape, lfo.center, lfo.depth, lfo.phase].join("|");
    if (waveCache.key !== key) {
        const preview = { ...lfo, enabled: true, period: 1 };
        const samples = Array.from({ length: 161 }, (_, i) => {
            const events = lfoWrites([preview], i / 80);
            return events.length ? events[0].value : lfo.center;
        });
        waveCache = { key, samples };
    }
    return waveCache.samples;
}

function drawWaveform(x, y, w, h, lfo, accent) {
    round(x, y, w, h, 7, colors.bg, colors.edge);
    const pad = 18, gw = w - 2 * pad, gh = h - 2 * pad;
    for (let i = 0; i <= 4; i++) line(x + pad, y + pad + i * gh / 4, x + w - pad, y + pad + i * gh / 4, colors.edge);
    for (let i = 0; i <= 8; i++) line(x + pad + i * gw / 8, y + pad, x + pad + i * gw / 8, y + h - pad, colors.edge);
    color(accent);
    mgraphics.set_line_width(2);
    waveformSamples(lfo).forEach((value, i) => {
        const px = x + pad + gw * i / 160, py = y + pad + gh * (1 - value / 127);
        if (i === 0) mgraphics.move_to(px, py);
        else mgraphics.line_to(px, py);
    });
    mgraphics.stroke();
    if (stateData.playing && lfo.enabled) {
        const progress = (stateData.beat / lfo.period) % 2 / 2;
        const px = x + pad + gw * progress;
        line(px, y + pad, px, y + h - pad, colors.gold, 1);
    }
}

function drawSong() {
    const song = stateData.song;
    if (!song || !song.lanes || !song.lanes.length) return emptyView("Song automation", "Draw a timeline of S‑4 parameter values.");
    section("Song automation", "Add points to a lane, and the transport plays back the curve over the song loop.");
    songLaneIndex = clamp(songLaneIndex, 0, song.lanes.length - 1);
    const lane = song.lanes[songLaneIndex];
    const accent = trackAccent(lane.track);
    const points = lane.points || [];
    songPointIndex = clamp(songPointIndex, 0, Math.max(0, points.length - 1));
    const point = points[songPointIndex];
    const set = (field, value) => emit("songlane", songLaneIndex, field, value);
    slotList(song.lanes, songLaneIndex, (i) => { songLaneIndex = i; songPointIndex = 0; },
        (slot) => "T" + (slot.track + 1) + " · " + parameterLabel(slot.id), (slot) => slot.enabled, "SONG LANES");
    controlLabel("TARGET TRACK", 246, 173);
    pickTrack(246, 184, 100, 32, lane.track, (value) => set("track", value));
    controlLabel("PARAMETER", 360, 173);
    pickParameter(360, 184, 223, 32, lane.id, (value) => set("id", value));
    button(596, 184, 94, 32, lane.enabled ? "Lane on" : "Lane off", () => set("enabled", lane.enabled ? 0 : 1), { active: lane.enabled });
    stepper(706, 173, 131, "LENGTH (BEATS)", song.length, (delta) => emit("song", "length", clamp(song.length + delta, 1, 256)));
    button(850, 184, 145, 32, song.enabled ? "Song enabled" : "Song disabled",
        () => emit("song", "enabled", song.enabled ? 0 : 1), { active: song.enabled });

    const x = 272, y = 257, w = 704, h = 215;
    round(246, 232, 749, 279, 8, colors.panel, colors.edge);
    rect(x, y, w, h, colors.bg);
    const xFor = (beat) => x + w * beat / song.length;
    const yFor = (value) => y + h * (1 - value / 127);
    const divisions = song.length >= 8 ? 8 : 4;
    for (let i = 0; i <= divisions; i++) {
        const beat = song.length * i / divisions;
        const xx = xFor(beat);
        line(xx, y, xx, y + h, colors.edge);
        textAt(Number(beat.toFixed(2)), xx, y + h + 19, { align: "center", size: 10, color: colors.secondary });
    }
    for (let i = 0; i <= 4; i++) line(x, y + h * i / 4, x + w, y + h * i / 4, colors.edge);
    textAt("127", x - 4, y + 8, { align: "right", size: 10, color: colors.secondary });
    textAt("0", x - 4, y + h, { align: "right", size: 10, color: colors.secondary });

    const shown = points.filter((item) => item.beat >= 0 && item.beat <= song.length);
    if (shown.length) {
        line(x, yFor(shown[0].value), xFor(shown[0].beat), yFor(shown[0].value), accent, 2);
        for (let i = 1; i < shown.length; i++) {
            const previous = shown[i - 1], current = shown[i];
            line(xFor(previous.beat), yFor(previous.value), xFor(current.beat), yFor(current.value), accent, 2);
        }
        const last = shown[shown.length - 1];
        line(xFor(last.beat), yFor(last.value), x + w, yFor(last.value), accent, 2);
    }

    let gestureBeat;
    const update = (_px, py) => {
        if (gestureBeat === undefined) return;
        const value = Math.round(127 * clamp(1 - (py - y) / h, 0, 1));
        emit("songpoint", songLaneIndex, gestureBeat, value);
    };
    hit(x, y, w, h, (px, py) => {
        gestureBeat = clamp(Math.round((px - x) / w * song.length * 4) / 4, 0, song.length);
        const index = points.findIndex((item) => item.beat >= gestureBeat);
        songPointIndex = index >= 0 ? index : points.length;
        update(px, py);
    }, update);
    shown.forEach((item) => {
        const px = xFor(item.beat), py = yFor(item.value);
        const index = points.indexOf(item);
        round(px - 5, py - 5, 10, 10, 5, index === songPointIndex ? colors.gold : accent, colors.bg);
        hit(px - 8, py - 8, 16, 16, () => {
            songPointIndex = index;
            gestureBeat = item.beat;
        }, update);
    });

    if (stateData.playing && song.enabled) {
        const xx = xFor(stateData.beat % song.length);
        line(xx, y, xx, y + h, colors.gold, 1);
    }
    if (point) {
        textAt("Beat " + point.beat + "  ·  Value " + point.value, 246, 535, { color: colors.secondary, size: 12 });
        button(851, 518, 144, 27, "Remove point", () => emit("songpoint", songLaneIndex, point.beat, -1), { size: 12 });
    }
    footer("Click to add a point on the quarter-beat grid. Drag a point vertically to adjust it.");
}

function drawPerformance() {
    const xy = stateData.xy;
    if (!xy) return emptyView("XY performance", "Send multiple S‑4 parameters from a two-dimensional pad.");
    section("XY performance", "Assign parameters to the horizontal or vertical axis. Drag the pad to send MIDI.");
    const x = 24, y = 178, w = 416, h = 348;
    const pad = 15, gw = w - 2 * pad, gh = h - 2 * pad;
    round(x, y, w, h, 9, colors.panel, colors.edge);
    for (let i = 0; i <= 8; i++) {
        const stroke = i === 4 ? colors.off : colors.edge;
        line(x + pad + gw * i / 8, y + pad, x + pad + gw * i / 8, y + h - pad, stroke);
        line(x + pad, y + pad + gh * i / 8, x + w - pad, y + pad + gh * i / 8, stroke);
    }
    const px = x + pad + gw * xy.x / 127, py = y + pad + gh * (1 - xy.y / 127);
    line(px, y + pad, px, y + h - pad, trackColors[1]);
    line(x + pad, py, x + w - pad, py, colors.accent);
    round(px - 7, py - 7, 14, 14, 7, colors.accent, colors.bg);
    const update = (mouseX, mouseY) => {
        const nextX = Math.round(clamp((mouseX - x - pad) / gw, 0, 1) * 127);
        const nextY = Math.round(clamp(1 - (mouseY - y - pad) / gh, 0, 1) * 127);
        emit("xy", nextX, nextY);
    };
    hit(x, y, w, h, update, update);
    textAt("X  " + xy.x + "     Y  " + xy.y, 466, 187, { size: 16, bold: true });
    button(897, 167, 98, 30, "Center", () => emit("xy", 64, 64));

    controlLabel("AXIS", 475, 218);
    controlLabel("TRACK", 544, 218);
    controlLabel("PARAMETER", 636, 218);
    controlLabel("LOW", 813, 218);
    controlLabel("HIGH", 885, 218);
    for (let i = 0; i < 4; i++) {
        const target = activeTarget(xy.targets, i);
        const yy = 230 + i * 71;
        const track = target ? target.track : (stateData.track || 0);
        const id = target ? target.id : "";
        const axis = target ? target.axis : (i % 2 ? "y" : "x");
        const min = target ? target.min : 0;
        const max = target ? target.max : 127;
        const set = (nextTrack, nextId, nextAxis, nextMin, nextMax) => emit("xytarget", i, nextTrack, nextId, nextAxis, nextMin, nextMax);
        round(466, yy, 529, 59, 7, colors.panel, colors.edge);
        if (target) {
            pickEnum(475, yy + 12, 61, 33, "Pad axis", [{ value: "x", label: "X" }, { value: "y", label: "Y" }],
                axis, (value) => set(track, id, value, min, max));
            pickTrack(544, yy + 12, 84, 33, track, (value) => set(value, id, axis, min, max));
        }
        pickParameter(636, yy + 12, 164, 33, id, (value) => set(track, value, axis, min, max));
        if (target) {
            textAt(min, 813, yy + 24, { size: 11, color: colors.secondary });
            slider(817, yy + 28, 46, 19, min, 0, 127, 1, (value) => set(track, id, axis, value, max));
            textAt(max, 885, yy + 24, { size: 11, color: colors.secondary });
            slider(889, yy + 28, 46, 19, max, 0, 127, 1, (value) => set(track, id, axis, min, value));
            button(953, yy + 12, 32, 33, "×", () => set(track, "none", axis, min, max));
        }
    }
    footer("Each axis can drive several parameters. Set the low and high values to shape the response.");
}

const views = {
    Control: drawControls,
    Sequencer: drawSequencer,
    Macros: drawMacros,
    LFOs: drawLFOs,
    Song: drawSong,
    Performance: drawPerformance
};

function paint() {
    const [w, h] = mgraphics.size;
    if (w <= 0 || h <= 0) return;
    viewport = [w, h];
    hitRegions = [];
    mgraphics.save();
    mgraphics.scale(w / width, h / height);
    header();
    views[tab]();
    if (picker) drawPicker();
    mgraphics.restore();
}
