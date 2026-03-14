//
//  ParameterDefaults.swift
//  Torso S4 Controller
//
//  Centralized default parameter IDs used across app state
//

import Foundation

struct ParameterDefaults {
    static let sequencerTrackSelection = "disc_speed"

    static let xyPadXAssignment = "mix_t1_level"
    static let xyPadYAssignment = "mix_t2_level"

    static let songTarget = "disc_speed"

    static let fieldNodeAssignments: [Int: String] = [
        1: "mix_t1_pan",
        2: "mix_t2_pan",
        3: "mix_t1_level",
        4: "mix_t2_level"
    ]
}
