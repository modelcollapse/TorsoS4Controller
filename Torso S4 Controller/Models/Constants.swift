//
//  Constants.swift
//  Torso S4 Controller
//
//  App-wide constants and parameter definitions
//

import Foundation

struct Constants {
    // MARK: - Tabs

    static let tabs: [String] = [
        "Control",
        "Sequencer",
        "LFOs",
        "Knobs",
        "Macros",
        "XY Pad",
        "Song",
        "Field",
        "Settings",
    ]

    // MARK: - Sections

    static let sections = [
        "disc",
        "tape",
        "poly",
        "mosaic",
        "ring",
        "deform",
        "vast",
        "wave",
        "adsr",
        "random",
        "waveModulator",
        "mix",
        "perform",
        "sends",
    ]

    // MARK: - MIDI Channels

    enum MIDIChannel: Int {
        case track1 = 0
        case track2 = 1
        case track3 = 2
        case track4 = 3
        case perform = 14
        case mix = 15
    }

    // MARK: - Parameter Definitions (CC Mappings)

    struct Parameter {
        let id: String
        let name: String
        let section: String
        let cc: Int
        let channel: MIDIChannel
        let defaultValue: Int = 64
    }

    static let parameters: [Parameter] = [
        // Disc Section
        Parameter(id: "disc_speed", name: "Speed", section: "disc", cc: 46, channel: .track1),
        Parameter(id: "disc_tempo", name: "Tempo", section: "disc", cc: 47, channel: .track1),
        Parameter(id: "disc_start", name: "Start", section: "disc", cc: 48, channel: .track1),
        Parameter(id: "disc_length", name: "Length", section: "disc", cc: 49, channel: .track1),
        Parameter(id: "disc_offset", name: "Offset", section: "disc", cc: 52, channel: .track1),
        Parameter(id: "disc_xfade", name: "Xfade", section: "disc", cc: 53, channel: .track1),
        Parameter(id: "disc_glide", name: "Glide", section: "disc", cc: 54, channel: .track1),
        Parameter(id: "disc_level", name: "Level", section: "disc", cc: 56, channel: .track1),

        // Tape Section
        Parameter(id: "tape_speed", name: "Speed", section: "tape", cc: 46, channel: .track1),
        Parameter(id: "tape_rotate", name: "Rotate", section: "tape", cc: 48, channel: .track1),
        Parameter(id: "tape_length", name: "Length", section: "tape", cc: 49, channel: .track1),
        Parameter(id: "tape_level", name: "Level", section: "tape", cc: 52, channel: .track1),

        // Poly Section
        Parameter(id: "poly_pitch", name: "Pitch", section: "poly", cc: 46, channel: .track1),
        Parameter(id: "poly_start", name: "Start", section: "poly", cc: 48, channel: .track1),
        Parameter(id: "poly_length", name: "Length", section: "poly", cc: 49, channel: .track1),
        Parameter(id: "poly_level", name: "Level", section: "poly", cc: 50, channel: .track1),

        // Mix Section
        Parameter(id: "mix_t1_level", name: "T1 Level", section: "mix", cc: 46, channel: .mix),
        Parameter(id: "mix_t1_filter", name: "T1 Filter", section: "mix", cc: 50, channel: .mix),
        Parameter(id: "mix_t1_pan", name: "T1 Pan", section: "mix", cc: 54, channel: .mix),
        Parameter(id: "mix_t2_level", name: "T2 Level", section: "mix", cc: 47, channel: .mix),
        Parameter(id: "mix_t2_filter", name: "T2 Filter", section: "mix", cc: 51, channel: .mix),
        Parameter(id: "mix_t2_pan", name: "T2 Pan", section: "mix", cc: 55, channel: .mix),
        Parameter(id: "mix_compress", name: "Compress", section: "mix", cc: 58, channel: .mix),
        Parameter(id: "mix_level", name: "Master Level", section: "mix", cc: 61, channel: .mix),

        // Perform/Macros
        Parameter(id: "perform_macro1", name: "Macro 1", section: "perform", cc: 46, channel: .perform),
        Parameter(id: "perform_macro2", name: "Macro 2", section: "perform", cc: 47, channel: .perform),
        Parameter(id: "perform_macro3", name: "Macro 3", section: "perform", cc: 48, channel: .perform),
        Parameter(id: "perform_macro4", name: "Macro 4", section: "perform", cc: 49, channel: .perform),
        Parameter(id: "perform_macro5", name: "Macro 5", section: "perform", cc: 50, channel: .perform),
        Parameter(id: "perform_macro6", name: "Macro 6", section: "perform", cc: 51, channel: .perform),
        Parameter(id: "perform_macro7", name: "Macro 7", section: "perform", cc: 52, channel: .perform),
        Parameter(id: "perform_macro8", name: "Macro 8", section: "perform", cc: 53, channel: .perform),
    ]

    static func getParameter(_ id: String) -> Parameter? {
        parameters.first { $0.id == id }
    }

    static func getParametersBySection(_ section: String) -> [Parameter] {
        parameters.filter { $0.section == section }
    }
}
