//
//  ParameterRegistry.swift
//  Torso S4 Controller
//
//  Single source of truth for app parameter definitions
//

import Foundation

struct ParameterRegistry {
    static let all: [Constants.Parameter] = [
        // Disc
        .init(id: "disc_speed", name: "Speed", section: "disc", cc: cc(S4CCMap.tape[.speed]), channel: .track1),
        .init(id: "disc_tempo", name: "Tempo", section: "disc", cc: cc(S4CCMap.tape[.tempo]), channel: .track1),
        .init(id: "disc_start", name: "Start", section: "disc", cc: cc(S4CCMap.tape[.start]), channel: .track1),
        .init(id: "disc_length", name: "Length", section: "disc", cc: cc(S4CCMap.tape[.length]), channel: .track1),
        .init(id: "disc_offset", name: "Offset", section: "disc", cc: cc(S4CCMap.tape[.rotate]), channel: .track1),
        .init(id: "disc_xfade", name: "Xfade", section: "disc", cc: cc(S4CCMap.tape[.xfade]), channel: .track1),
        .init(id: "disc_glide", name: "Glide", section: "disc", cc: cc(S4CCMap.tape[.glide]), channel: .track1),
        .init(id: "disc_level", name: "Level", section: "disc", cc: cc(S4CCMap.tape[.level]), channel: .track1),

        // Tape
        .init(id: "tape_speed", name: "Speed", section: "tape", cc: cc(S4CCMap.tape[.speed]), channel: .track1),
        .init(id: "tape_rotate", name: "Rotate", section: "tape", cc: cc(S4CCMap.tape[.start]), channel: .track1),
        .init(id: "tape_length", name: "Length", section: "tape", cc: cc(S4CCMap.tape[.length]), channel: .track1),
        .init(id: "tape_level", name: "Level", section: "tape", cc: cc(S4CCMap.tape[.rotate]), channel: .track1),

        // Poly
        .init(id: "poly_pitch", name: "Pitch", section: "poly", cc: cc(S4CCMap.poly[.pitch]), channel: .track1),
        .init(id: "poly_start", name: "Start", section: "poly", cc: cc(S4CCMap.poly[.start]), channel: .track1),
        .init(id: "poly_length", name: "Length", section: "poly", cc: cc(S4CCMap.poly[.length]), channel: .track1),
        .init(id: "poly_level", name: "Level", section: "poly", cc: cc(S4CCMap.poly[.level]), channel: .track1),

        // Mix
        .init(id: "mix_t1_level", name: "T1 Level", section: "mix", cc: cc(S4CCMap.mix[.track1Level]), channel: .mix),
        .init(id: "mix_t1_filter", name: "T1 Filter", section: "mix", cc: cc(S4CCMap.mix[.track1Filter]), channel: .mix),
        .init(id: "mix_t1_pan", name: "T1 Pan", section: "mix", cc: cc(S4CCMap.mix[.track1Pan]), channel: .mix),
        .init(id: "mix_t2_level", name: "T2 Level", section: "mix", cc: cc(S4CCMap.mix[.track2Level]), channel: .mix),
        .init(id: "mix_t2_filter", name: "T2 Filter", section: "mix", cc: cc(S4CCMap.mix[.track2Filter]), channel: .mix),
        .init(id: "mix_t2_pan", name: "T2 Pan", section: "mix", cc: cc(S4CCMap.mix[.track2Pan]), channel: .mix),
        .init(id: "mix_compress", name: "Compress", section: "mix", cc: cc(S4CCMap.mix[.compress]), channel: .mix),
        .init(id: "mix_level", name: "Master Level", section: "mix", cc: cc(S4CCMap.mix[.mainLevel]), channel: .mix),

        // Perform / Macros
        .init(id: "perform_macro1", name: "Macro 1", section: "perform", cc: 46, channel: .perform),
        .init(id: "perform_macro2", name: "Macro 2", section: "perform", cc: 47, channel: .perform),
        .init(id: "perform_macro3", name: "Macro 3", section: "perform", cc: 48, channel: .perform),
        .init(id: "perform_macro4", name: "Macro 4", section: "perform", cc: 49, channel: .perform),
        .init(id: "perform_macro5", name: "Macro 5", section: "perform", cc: 50, channel: .perform),
        .init(id: "perform_macro6", name: "Macro 6", section: "perform", cc: 51, channel: .perform),
        .init(id: "perform_macro7", name: "Macro 7", section: "perform", cc: 52, channel: .perform),
        .init(id: "perform_macro8", name: "Macro 8", section: "perform", cc: 53, channel: .perform),
    ]

    static func parameter(withID id: String) -> Constants.Parameter? {
        all.first { $0.id == id }
    }

    static func parameters(inSection section: String) -> [Constants.Parameter] {
        all.filter { $0.section == section }
    }

    static func sectionIDsWithParameters() -> [String] {
        let orderedSections = Constants.sections
        return orderedSections.filter { !parameters(inSection: $0).isEmpty }
    }

    static func displayName(forSection sectionID: String) -> String {
        switch sectionID {
        case "disc": return "Disc"
        case "tape": return "Tape"
        case "poly": return "Poly"
        case "mosaic": return "Mosaic"
        case "ring": return "Ring"
        case "deform": return "Deform"
        case "vast": return "Vast"
        case "wave": return "Wave"
        case "adsr": return "ADSR"
        case "random": return "Random"
        case "waveModulator": return "Wave Mod"
        case "mix": return "Mix"
        case "perform": return "Perform"
        case "sends": return "Sends"
        default: return sectionID.capitalized
        }
    }

    private static func cc(_ binding: S4CCBinding?) -> Int {
        binding?.cc ?? 0
    }
}
