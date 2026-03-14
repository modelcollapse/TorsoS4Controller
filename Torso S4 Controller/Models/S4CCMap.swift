//
//  S4CCMap.swift
//  Torso S4 Controller
//
//  DEV HANDOFF NOTE
//  2026-03-13 15:53 local
//
//  Purpose:
//  Source-of-truth MIDI CC and note mapping layer for the Torso S-4.
//
//  Current modeling decisions:
//  - Track-scoped controls use the selected track MIDI channel.
//  - Mix-scoped controls use MIDI channel 16.
//  - Device/page semantics are separated from raw CC numbers.
//  - This file is intentionally typed and grouped by real S-4 sections.
//
//  Next files expected after this:
//  - S4ParameterModel.swift
//  - S4MIDITranslator.swift
//

import Foundation

enum S4MIDIScope: String, CaseIterable, Codable {
    case track
    case mix
}

enum S4ChannelBehavior: Codable, Equatable {
    case selectedTrack
    case fixed(Int)

    var resolvedFallbackChannel: Int {
        switch self {
        case .selectedTrack:
            return 1
        case .fixed(let channel):
            return channel
        }
    }
}

struct S4CCBinding: Codable, Equatable {
    let label: String
    let cc: Int
    let channelBehavior: S4ChannelBehavior

    init(_ label: String, cc: Int, channelBehavior: S4ChannelBehavior) {
        self.label = label
        self.cc = cc
        self.channelBehavior = channelBehavior
    }
}

struct S4NoteBinding: Codable, Equatable {
    let label: String
    let note: Int
    let channelBehavior: S4ChannelBehavior

    init(_ label: String, note: Int, channelBehavior: S4ChannelBehavior) {
        self.label = label
        self.note = note
        self.channelBehavior = channelBehavior
    }
}

enum S4TrackSendParameter: String, CaseIterable, Codable {
    case send1
    case send2
    case send3
    case send4
}

enum S4ModSlot: Int, CaseIterable, Codable {
    case mod1 = 1
    case mod2 = 2
    case mod3 = 3
    case mod4 = 4
}

enum S4WaveParameter: String, CaseIterable, Codable {
    case rate
    case amount
    case phase
    case offset
    case skew
    case fold
    case curve
    case spread
}

enum S4RandomParameter: String, CaseIterable, Codable {
    case rate
    case amount
    case phase
    case offset
    case spread
    case variation
    case smooth
    case length
}

enum S4ADSRParameter: String, CaseIterable, Codable {
    case attack
    case decay
    case sustain
    case release
    case attackCurve
    case decayCurve
    case releaseCurve
    case spread
}

enum S4TapeParameter: String, CaseIterable, Codable {
    case speed
    case tempo
    case start
    case length
    case rotate
    case xfade
    case glide
    case level
    case sos
}

enum S4PolyParameter: String, CaseIterable, Codable {
    case pitch
    case start
    case length
    case level
    case loop
    case xfade
    case attack
    case decay
    case sustain
    case curve
    case velocity
    case filterAmount
    case filterShape
}

enum S4MosaicParameter: String, CaseIterable, Codable {
    case pitch
    case rate
    case size
    case contour
    case warp
    case spray
    case pattern
    case wet
    case detune
    case randomRate
    case randomSize
    case sos
}

enum S4RingParameter: String, CaseIterable, Codable {
    case cutoff
    case resonance
    case decay
    case pitch
    case slope
    case tone
    case scale
    case wet
    case waves
    case noise
    case tilt
    case detune
    case wavesRate
    case noiseRate
}

enum S4DeformParameter: String, CaseIterable, Codable {
    case drive
    case compress
    case crush
    case tilt
    case noise
    case noiseDecay
    case noiseColor
    case wet
}

enum S4VastParameter: String, CaseIterable, Codable {
    case delay
    case time
    case reverb
    case size
    case feedback
    case spread
    case damp
    case decay
}

enum S4MixParameter: String, CaseIterable, Codable {
    case track1Level
    case track2Level
    case track3Level
    case track4Level
    case track1Filter
    case track2Filter
    case track3Filter
    case track4Filter
    case track1Pan
    case track2Pan
    case track3Pan
    case track4Pan
    case compress
    case mainLevel
}

enum S4TransportNote: String, CaseIterable, Codable {
    case playStop
    case mute1
    case mute2
    case mute3
    case mute4
}

enum S4CCMap {
    static let mixChannel = 16

    static let trackSends: [S4TrackSendParameter: S4CCBinding] = [
        .send1: .init("Track Send 1", cc: 10, channelBehavior: .selectedTrack),
        .send2: .init("Track Send 2", cc: 11, channelBehavior: .selectedTrack),
        .send3: .init("Track Send 3", cc: 12, channelBehavior: .selectedTrack),
        .send4: .init("Track Send 4", cc: 13, channelBehavior: .selectedTrack)
    ]

    static let waveModCCsBySlot: [S4ModSlot: [S4WaveParameter: S4CCBinding]] = [
        .mod1: makeWaveMap(startingAt: 14, labelPrefix: "Mod 1 Wave"),
        .mod2: makeWaveMap(startingAt: 22, labelPrefix: "Mod 2 Wave"),
        .mod3: makeWaveMap(startingAt: 30, labelPrefix: "Mod 3 Wave"),
        .mod4: makeWaveMap(startingAt: 38, labelPrefix: "Mod 4 Wave")
    ]

    static let randomModCCsBySlot: [S4ModSlot: [S4RandomParameter: S4CCBinding]] = [
        .mod1: makeRandomMap(startingAt: 14, labelPrefix: "Mod 1 Random"),
        .mod2: makeRandomMap(startingAt: 22, labelPrefix: "Mod 2 Random"),
        .mod3: makeRandomMap(startingAt: 30, labelPrefix: "Mod 3 Random"),
        .mod4: makeRandomMap(startingAt: 38, labelPrefix: "Mod 4 Random")
    ]

    static let adsrModCCsBySlot: [S4ModSlot: [S4ADSRParameter: S4CCBinding]] = [
        .mod1: makeADSRMap(startingAt: 14, labelPrefix: "Mod 1 ADSR"),
        .mod2: makeADSRMap(startingAt: 22, labelPrefix: "Mod 2 ADSR"),
        .mod3: makeADSRMap(startingAt: 30, labelPrefix: "Mod 3 ADSR"),
        .mod4: makeADSRMap(startingAt: 38, labelPrefix: "Mod 4 ADSR")
    ]

    static let tape: [S4TapeParameter: S4CCBinding] = [
        .speed: .init("Tape Speed", cc: 46, channelBehavior: .selectedTrack),
        .tempo: .init("Tape Tempo", cc: 47, channelBehavior: .selectedTrack),
        .start: .init("Tape Start", cc: 48, channelBehavior: .selectedTrack),
        .length: .init("Tape Length", cc: 49, channelBehavior: .selectedTrack),
        .rotate: .init("Tape Rotate", cc: 52, channelBehavior: .selectedTrack),
        .xfade: .init("Tape XFade", cc: 53, channelBehavior: .selectedTrack),
        .glide: .init("Tape Glide", cc: 54, channelBehavior: .selectedTrack),
        .level: .init("Tape Level", cc: 56, channelBehavior: .selectedTrack),
        .sos: .init("Tape SOS", cc: 57, channelBehavior: .selectedTrack)
    ]

    static let poly: [S4PolyParameter: S4CCBinding] = [
        .pitch: .init("Poly Pitch", cc: 46, channelBehavior: .selectedTrack),
        .start: .init("Poly Start", cc: 48, channelBehavior: .selectedTrack),
        .length: .init("Poly Length", cc: 49, channelBehavior: .selectedTrack),
        .level: .init("Poly Level", cc: 50, channelBehavior: .selectedTrack),
        .loop: .init("Poly Loop", cc: 52, channelBehavior: .selectedTrack),
        .xfade: .init("Poly XFade", cc: 53, channelBehavior: .selectedTrack),
        .attack: .init("Poly Attack", cc: 54, channelBehavior: .selectedTrack),
        .decay: .init("Poly Decay", cc: 55, channelBehavior: .selectedTrack),
        .sustain: .init("Poly Sustain", cc: 56, channelBehavior: .selectedTrack),
        .curve: .init("Poly Curve", cc: 57, channelBehavior: .selectedTrack),
        .velocity: .init("Poly Velocity", cc: 58, channelBehavior: .selectedTrack),
        .filterAmount: .init("Poly Filter Amount", cc: 60, channelBehavior: .selectedTrack),
        .filterShape: .init("Poly Filter Shape", cc: 61, channelBehavior: .selectedTrack)
    ]

    static let mosaic: [S4MosaicParameter: S4CCBinding] = [
        .pitch: .init("Mosaic Pitch", cc: 63, channelBehavior: .selectedTrack),
        .rate: .init("Mosaic Rate", cc: 64, channelBehavior: .selectedTrack),
        .size: .init("Mosaic Size", cc: 65, channelBehavior: .selectedTrack),
        .contour: .init("Mosaic Contour", cc: 66, channelBehavior: .selectedTrack),
        .warp: .init("Mosaic Warp", cc: 67, channelBehavior: .selectedTrack),
        .spray: .init("Mosaic Spray", cc: 68, channelBehavior: .selectedTrack),
        .pattern: .init("Mosaic Pattern", cc: 69, channelBehavior: .selectedTrack),
        .wet: .init("Mosaic Wet", cc: 70, channelBehavior: .selectedTrack),
        .detune: .init("Mosaic Detune", cc: 71, channelBehavior: .selectedTrack),
        .randomRate: .init("Mosaic Random Rate", cc: 72, channelBehavior: .selectedTrack),
        .randomSize: .init("Mosaic Random Size", cc: 73, channelBehavior: .selectedTrack),
        .sos: .init("Mosaic SOS", cc: 74, channelBehavior: .selectedTrack)
    ]

    static let ring: [S4RingParameter: S4CCBinding] = [
        .cutoff: .init("Ring Cutoff", cc: 78, channelBehavior: .selectedTrack),
        .resonance: .init("Ring Resonance", cc: 79, channelBehavior: .selectedTrack),
        .decay: .init("Ring Decay", cc: 80, channelBehavior: .selectedTrack),
        .pitch: .init("Ring Pitch", cc: 81, channelBehavior: .selectedTrack),
        .slope: .init("Ring Slope", cc: 82, channelBehavior: .selectedTrack),
        .tone: .init("Ring Tone", cc: 83, channelBehavior: .selectedTrack),
        .scale: .init("Ring Scale", cc: 84, channelBehavior: .selectedTrack),
        .wet: .init("Ring Wet", cc: 85, channelBehavior: .selectedTrack),
        .waves: .init("Ring Waves", cc: 86, channelBehavior: .selectedTrack),
        .noise: .init("Ring Noise", cc: 87, channelBehavior: .selectedTrack),
        .tilt: .init("Ring Tilt", cc: 88, channelBehavior: .selectedTrack),
        .detune: .init("Ring Detune", cc: 89, channelBehavior: .selectedTrack),
        .wavesRate: .init("Ring Waves Rate", cc: 90, channelBehavior: .selectedTrack),
        .noiseRate: .init("Ring Noise Rate", cc: 91, channelBehavior: .selectedTrack)
    ]

    static let deform: [S4DeformParameter: S4CCBinding] = [
        .drive: .init("Deform Drive", cc: 94, channelBehavior: .selectedTrack),
        .compress: .init("Deform Compress", cc: 95, channelBehavior: .selectedTrack),
        .crush: .init("Deform Crush", cc: 96, channelBehavior: .selectedTrack),
        .tilt: .init("Deform Tilt", cc: 97, channelBehavior: .selectedTrack),
        .noise: .init("Deform Noise", cc: 98, channelBehavior: .selectedTrack),
        .noiseDecay: .init("Deform Noise Decay", cc: 99, channelBehavior: .selectedTrack),
        .noiseColor: .init("Deform Noise Color", cc: 100, channelBehavior: .selectedTrack),
        .wet: .init("Deform Wet", cc: 101, channelBehavior: .selectedTrack)
    ]

    static let vast: [S4VastParameter: S4CCBinding] = [
        .delay: .init("Vast Delay", cc: 110, channelBehavior: .selectedTrack),
        .time: .init("Vast Time", cc: 111, channelBehavior: .selectedTrack),
        .reverb: .init("Vast Reverb", cc: 112, channelBehavior: .selectedTrack),
        .size: .init("Vast Size", cc: 113, channelBehavior: .selectedTrack),
        .feedback: .init("Vast Feedback", cc: 114, channelBehavior: .selectedTrack),
        .spread: .init("Vast Spread", cc: 115, channelBehavior: .selectedTrack),
        .damp: .init("Vast Damp", cc: 116, channelBehavior: .selectedTrack),
        .decay: .init("Vast Decay", cc: 117, channelBehavior: .selectedTrack)
    ]

    static let mix: [S4MixParameter: S4CCBinding] = [
        .track1Level: .init("Mix Track 1 Level", cc: 46, channelBehavior: .fixed(mixChannel)),
        .track2Level: .init("Mix Track 2 Level", cc: 47, channelBehavior: .fixed(mixChannel)),
        .track3Level: .init("Mix Track 3 Level", cc: 48, channelBehavior: .fixed(mixChannel)),
        .track4Level: .init("Mix Track 4 Level", cc: 49, channelBehavior: .fixed(mixChannel)),
        .track1Filter: .init("Mix Track 1 Filter", cc: 50, channelBehavior: .fixed(mixChannel)),
        .track2Filter: .init("Mix Track 2 Filter", cc: 51, channelBehavior: .fixed(mixChannel)),
        .track3Filter: .init("Mix Track 3 Filter", cc: 52, channelBehavior: .fixed(mixChannel)),
        .track4Filter: .init("Mix Track 4 Filter", cc: 53, channelBehavior: .fixed(mixChannel)),
        .track1Pan: .init("Mix Track 1 Pan", cc: 54, channelBehavior: .fixed(mixChannel)),
        .track2Pan: .init("Mix Track 2 Pan", cc: 55, channelBehavior: .fixed(mixChannel)),
        .track3Pan: .init("Mix Track 3 Pan", cc: 56, channelBehavior: .fixed(mixChannel)),
        .track4Pan: .init("Mix Track 4 Pan", cc: 57, channelBehavior: .fixed(mixChannel)),
        .compress: .init("Mix Compress", cc: 58, channelBehavior: .fixed(mixChannel)),
        .mainLevel: .init("Mix Main Level", cc: 61, channelBehavior: .fixed(mixChannel))
    ]

    static let transportNotes: [S4TransportNote: S4NoteBinding] = [
        .playStop: .init("Play / Stop", note: 24, channelBehavior: .fixed(mixChannel)),
        .mute1: .init("Mute Track 1", note: 25, channelBehavior: .fixed(mixChannel)),
        .mute2: .init("Mute Track 2", note: 26, channelBehavior: .fixed(mixChannel)),
        .mute3: .init("Mute Track 3", note: 27, channelBehavior: .fixed(mixChannel)),
        .mute4: .init("Mute Track 4", note: 28, channelBehavior: .fixed(mixChannel))
    ]

    private static func makeWaveMap(startingAt start: Int, labelPrefix: String) -> [S4WaveParameter: S4CCBinding] {
        [
            .rate: .init("\(labelPrefix) Rate", cc: start + 0, channelBehavior: .selectedTrack),
            .amount: .init("\(labelPrefix) Amount", cc: start + 1, channelBehavior: .selectedTrack),
            .phase: .init("\(labelPrefix) Phase", cc: start + 2, channelBehavior: .selectedTrack),
            .offset: .init("\(labelPrefix) Offset", cc: start + 3, channelBehavior: .selectedTrack),
            .skew: .init("\(labelPrefix) Skew", cc: start + 4, channelBehavior: .selectedTrack),
            .fold: .init("\(labelPrefix) Fold", cc: start + 5, channelBehavior: .selectedTrack),
            .curve: .init("\(labelPrefix) Curve", cc: start + 6, channelBehavior: .selectedTrack),
            .spread: .init("\(labelPrefix) Spread", cc: start + 7, channelBehavior: .selectedTrack)
        ]
    }

    private static func makeRandomMap(startingAt start: Int, labelPrefix: String) -> [S4RandomParameter: S4CCBinding] {
        [
            .rate: .init("\(labelPrefix) Rate", cc: start + 0, channelBehavior: .selectedTrack),
            .amount: .init("\(labelPrefix) Amount", cc: start + 1, channelBehavior: .selectedTrack),
            .phase: .init("\(labelPrefix) Phase", cc: start + 2, channelBehavior: .selectedTrack),
            .offset: .init("\(labelPrefix) Offset", cc: start + 3, channelBehavior: .selectedTrack),
            .spread: .init("\(labelPrefix) Spread", cc: start + 4, channelBehavior: .selectedTrack),
            .variation: .init("\(labelPrefix) Variation", cc: start + 5, channelBehavior: .selectedTrack),
            .smooth: .init("\(labelPrefix) Smooth", cc: start + 6, channelBehavior: .selectedTrack),
            .length: .init("\(labelPrefix) Length", cc: start + 7, channelBehavior: .selectedTrack)
        ]
    }

    private static func makeADSRMap(startingAt start: Int, labelPrefix: String) -> [S4ADSRParameter: S4CCBinding] {
        [
            .attack: .init("\(labelPrefix) Attack", cc: start + 0, channelBehavior: .selectedTrack),
            .decay: .init("\(labelPrefix) Decay", cc: start + 1, channelBehavior: .selectedTrack),
            .sustain: .init("\(labelPrefix) Sustain", cc: start + 2, channelBehavior: .selectedTrack),
            .release: .init("\(labelPrefix) Release", cc: start + 3, channelBehavior: .selectedTrack),
            .attackCurve: .init("\(labelPrefix) Attack Curve", cc: start + 4, channelBehavior: .selectedTrack),
            .decayCurve: .init("\(labelPrefix) Decay Curve", cc: start + 5, channelBehavior: .selectedTrack),
            .releaseCurve: .init("\(labelPrefix) Release Curve", cc: start + 6, channelBehavior: .selectedTrack),
            .spread: .init("\(labelPrefix) Spread", cc: start + 7, channelBehavior: .selectedTrack)
        ]
    }
}
