'use strict';

// IDs follow the Swift ParameterRegistry where the parameter still exists.
// Hardware CCs and names follow the current Torso S-4 chart:
// https://docs.torsoelectronics.com/s4/appendix/cc-mapping-and-midi-note-reference/
// The older Swift Tape, Mosaic and Random maps differ from this chart.
// Material and modulator types share CCs. The active device or modulator on the
// S-4 determines which parameter responds. Selecting an ID cannot switch it.
// Track sends are omitted: Torso's older chart marked them inactive, and the
// current chart does not list them. This registry covers CCs, not MIDI notes.

const groups = Object.freeze({
    disc: 'Disc',
    tape: 'Tape',
    poly: 'Poly',
    mosaic: 'Mosaic',
    ring: 'Ring',
    deform: 'Deform',
    vast: 'Vast',
    wave: 'Wave',
    random: 'Random',
    adsr: 'ADSR',
    follow: 'Follow',
    mix: 'Mix',
    perform: 'Perform'
});

const deviceCCs = {
    disc: [
        ['speed', 'Speed', 46],
        ['tempo', 'Tempo', 47],
        ['start', 'Start', 48],
        ['length', 'Length', 49],
        ['offset', 'Offset', 52],
        ['xfade', 'Crossfade', 53],
        ['glide', 'Glide', 54],
        ['level', 'Level', 56],
        ['sos', 'SOS', 57],
        ['density', 'Density', 58]
    ],
    tape: [
        ['speed', 'Speed', 46],
        ['rotate', 'Rotate', 48],
        ['length', 'Length', 49],
        ['sos', 'SOS', 51],
        ['level', 'Level', 52],
        ['xfade', 'Crossfade', 53]
    ],
    poly: [
        ['pitch', 'Pitch', 46],
        ['start', 'Start', 48],
        ['length', 'Length', 49],
        ['level', 'Level', 50],
        ['loop', 'Loop', 52],
        ['xfade', 'Crossfade', 53],
        ['attack', 'Attack', 54],
        ['decay', 'Decay', 55],
        ['sustain', 'Sustain', 56],
        ['curve', 'Curve', 57],
        ['velocity', 'Velocity', 58],
        ['filter_amount', 'Filter Amount', 60],
        ['filter_shape', 'Filter Shape', 61]
    ],
    mosaic: [
        ['pitch', 'Pitch', 62],
        ['rate', 'Rate', 63],
        ['size', 'Size', 64],
        ['contour', 'Contour', 65],
        ['scan', 'Scan', 66],
        ['spray', 'Spray', 67],
        ['pattern', 'Pattern', 68],
        ['wet', 'Wet', 69],
        ['random_pitch', 'Random Pitch', 70],
        ['random_rate', 'Random Rate', 71],
        ['random_size', 'Random Size', 72],
        ['random_amp', 'Random Amplitude', 73],
        ['random_rev', 'Random Reverse', 74],
        ['feedback', 'Feedback', 77]
    ],
    ring: [
        ['cutoff', 'Cutoff', 78],
        ['resonance', 'Resonance', 79],
        ['decay', 'Decay', 80],
        ['pitch', 'Pitch', 81],
        ['slope', 'Slope', 82],
        ['tone', 'Tone', 83],
        ['scale', 'Scale', 84],
        ['wet', 'Wet', 85],
        ['waves', 'Waves', 86],
        ['noise', 'Noise', 87],
        ['tilt', 'Tilt', 88],
        ['detune', 'Detune', 89],
        ['waves_rate', 'Waves Rate', 90],
        ['noise_rate', 'Noise Rate', 91]
    ],
    deform: [
        ['drive', 'Drive', 94],
        ['compress', 'Compress', 95],
        ['crush', 'Crush', 96],
        ['tilt', 'Tilt', 97],
        ['noise', 'Noise', 98],
        ['noise_decay', 'Noise Decay', 99],
        ['noise_tone', 'Noise Tone', 100],
        ['wet', 'Wet', 101]
    ],
    vast: [
        ['delay', 'Delay', 110],
        ['time', 'Time', 111],
        ['reverb', 'Reverb', 112],
        ['size', 'Size', 113],
        ['feedback', 'Feedback', 114],
        ['spread', 'Spread', 115],
        ['tone', 'Tone', 116],
        ['decay', 'Decay', 117]
    ]
};

const waveEncoders = [
    ['rate', 'Rate'], ['amount', 'Amount'], ['phase', 'Phase'], ['offset', 'Offset'],
    ['skew', 'Skew'], ['fold', 'Fold'], ['curve', 'Curve'], ['spread', 'Spread']
];

const modulatorEncoders = {
    wave: waveEncoders,
    random: [
        ['rate', 'Rate'], ['amount', 'Amount'], ['phase', 'Phase'], ['offset', 'Offset'],
        ['length', 'Length'], ['variation', 'Variation'], ['smooth', 'Smooth'], ['spread', 'Spread']
    ],
    adsr: [
        ['attack', 'Attack'], ['decay', 'Decay'], ['sustain', 'Sustain'], ['release', 'Release'],
        ['attackCurve', 'Attack Curve'], ['decayCurve', 'Decay Curve'],
        ['releaseCurve', 'Release Curve'], ['spread', 'Spread']
    ],
    follow: waveEncoders
};

function parameter(id, label, group, cc, channel) {
    const entry = { id, label, group, cc, scope: 'track', min: 0, max: 127 };
    if (channel !== undefined) {
        entry.scope = 'global';
        entry.channel = channel;
    }
    return Object.freeze(entry);
}

const parameters = [];

for (const [group, rows] of Object.entries(deviceCCs)) {
    for (const [id, label, cc] of rows) {
        parameters.push(parameter(`${group}_${id}`, `${groups[group]} ${label}`, group, cc));
    }
}

for (const [group, encoders] of Object.entries(modulatorEncoders)) {
    for (let slot = 1; slot <= 4; slot++) {
        const firstCC = 14 + (slot - 1) * 8;
        encoders.forEach(([id, label], index) => {
            parameters.push(parameter(`${group}_m${slot}_${id}`, `${groups[group]} ${slot} ${label}`,
                group, firstCC + index));
        });
    }
}

for (const [id, label, firstCC] of [['level', 'Level', 46], ['filter', 'Filter', 50], ['pan', 'Pan', 54]]) {
    for (let track = 1; track <= 4; track++) {
        parameters.push(parameter(`mix_t${track}_${id}`, `Mix Track ${track} ${label}`,
            'mix', firstCC + track - 1, 16));
    }
}
parameters.push(parameter('mix_compress', 'Mix Compress', 'mix', 58, 16));
parameters.push(parameter('mix_level', 'Mix Main Level', 'mix', 61, 16));

for (let macro = 1; macro <= 8; macro++) {
    parameters.push(parameter(`perform_macro${macro}`, `Perform Macro ${macro}`, 'perform', 45 + macro, 15));
}

const parametersById = Object.create(null);
for (const entry of parameters) parametersById[entry.id] = entry;

exports.parameters = Object.freeze(parameters);
exports.parametersById = Object.freeze(parametersById);
exports.groups = groups;
exports.defaultLaneIds = Object.freeze(['disc_speed', 'ring_cutoff', 'mosaic_wet', 'vast_reverb']);
