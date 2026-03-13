//
//  AppState.swift
//  Torso S4 Controller
//
//  Global state management for the S4 MIDI Controller
//

import SwiftUI

enum TabSelection: String, CaseIterable {
    case control = "Control"
    case sequencer = "Sequencer"
    case lfos = "LFOs"
    case knobs = "Knobs"
    case macros = "Macros"
    case xypad = "XY Pad"
    case song = "Song"
    case field = "Field"
    case settings = "Settings"
}

@MainActor
class AppState: ObservableObject {
    @Published var selectedTab: TabSelection = .control
    @Published var bpm: Int = 120
    @Published var isPlaying: Bool = false
    @Published var isMIDIConnected: Bool = false

    // Parameter values (0-127)
    @Published var parameterValues: [String: Int] = [:]

    // Snapshots (S1-S8)
    @Published var snapshots: [Int: [String: Int]] = [:]

    // LFO assignments: parameter ID -> (lfo index, depth, enabled)
    @Published var lfoAssignments: [String: (lfoIndex: Int, depth: Int, enabled: Bool)] = [:]

    // UI state
    @Published var expandedSections: Set<String> = []
    @Published var activeTracks: Set<Int> = [1, 2, 3, 4]

    init() {
        initializeSnapshots()
    }

    private func initializeSnapshots() {
        for i in 1...8 {
            snapshots[i] = [:]
        }
    }

    func toggleSection(_ sectionID: String) {
        if expandedSections.contains(sectionID) {
            expandedSections.remove(sectionID)
        } else {
            expandedSections.insert(sectionID)
        }
    }

    func setParameterValue(_ paramID: String, _ value: Int) {
        parameterValues[paramID] = max(0, min(127, value))
    }

    func getParameterValue(_ paramID: String) -> Int {
        parameterValues[paramID] ?? 64
    }

    func toggleTrack(_ track: Int) {
        if activeTracks.contains(track) {
            activeTracks.remove(track)
        } else {
            activeTracks.insert(track)
        }
    }

    func saveSnapshot(_ slot: Int) {
        snapshots[slot] = parameterValues
    }

    func loadSnapshot(_ slot: Int) {
        if let snapshot = snapshots[slot] {
            parameterValues = snapshot
        }
    }
}
