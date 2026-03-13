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

    // SEQUENCER
    @Published var sequencerTracks: [String: [Bool]] = [:]
    @Published var sequencerRate: Int = 64
    @Published var sequencerDirection: String = "FWD"
    @Published var isSequencerPlaying: Bool = false
    @Published var sequencerTrackSelection: String = "disc_speed"

    // LFOs
    @Published var lfos: [Int: LFOModel] = [:]

    // KNOBS (Performance)
    @Published var performanceKnobs: [Int: Int] = [:]
    @Published var isRecording: Bool = false

    // MACROS
    @Published var macroValues: [Int: Int] = [:]
    @Published var macroAssignments: [Int: [(paramID: String, minScale: Int, maxScale: Int)]] = [:]

    // XY PAD
    @Published var xyPadPosition: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @Published var xyPadXAssignment: String = "mix_t1_level"
    @Published var xyPadYAssignment: String = "mix_t2_level"

    // SONG (Automation)
    @Published var songLength: Int = 32
    @Published var songLoop: Bool = true
    @Published var songTarget: String = "disc_speed"
    @Published var songCurves: [String: [CGPoint]] = [:]

    // FIELD
    @Published var fieldNodes: [Int: CGPoint] = [:]
    @Published var fieldAssignments: [Int: String] = [:]

    // SETTINGS
    @Published var themeMode: String = "dark"
    @Published var midiInputDevice: String = "None"
    @Published var midiOutputDevice: String = "None"
    @Published var protectMix: Bool = false
    @Published var allSoundOffOnPanic: Bool = true
    @Published var resetCCOnStartup: Bool = false

    init() {
        initializeSnapshots()
        initializePerformanceKnobs()
        initializeMacros()
        initializeFieldNodes()
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

    // MARK: - Initialization Helpers

    private func initializePerformanceKnobs() {
        for i in 1...8 {
            performanceKnobs[i] = 64
        }
    }

    private func initializeMacros() {
        for i in 1...16 {
            macroValues[i] = 64
            macroAssignments[i] = []
        }
    }

    private func initializeFieldNodes() {
        fieldNodes[1] = CGPoint(x: 0.25, y: 0.25)
        fieldNodes[2] = CGPoint(x: 0.75, y: 0.25)
        fieldNodes[3] = CGPoint(x: 0.25, y: 0.75)
        fieldNodes[4] = CGPoint(x: 0.75, y: 0.75)

        fieldAssignments[1] = "mix_t1_pan"
        fieldAssignments[2] = "mix_t2_pan"
        fieldAssignments[3] = "mix_t1_level"
        fieldAssignments[4] = "mix_t2_level"
    }

    // MARK: - Sequencer Methods

    func updateStep(track: String, step: Int, enabled: Bool) {
        if sequencerTracks[track] == nil {
            sequencerTracks[track] = Array(repeating: false, count: 16)
        }
        if step >= 0 && step < 16 {
            sequencerTracks[track]?[step] = enabled
        }
    }

    // MARK: - LFO Methods

    func addLFO() {
        let newIndex = (lfos.keys.max() ?? 0) + 1
        lfos[newIndex] = LFOModel()
    }

    func removeLFO(_ index: Int) {
        lfos.removeValue(forKey: index)
    }

    func updateLFO(_ index: Int, enabled: Bool? = nil, waveform: String? = nil,
                   rate: Int? = nil, depth: Int? = nil, phase: Int? = nil,
                   bpmSync: Bool? = nil) {
        guard var lfo = lfos[index] else { return }
        if let enabled = enabled { lfo.enabled = enabled }
        if let waveform = waveform { lfo.waveform = waveform }
        if let rate = rate { lfo.rate = max(0, min(127, rate)) }
        if let depth = depth { lfo.depth = max(0, min(127, depth)) }
        if let phase = phase { lfo.phase = max(0, min(127, phase)) }
        if let bpmSync = bpmSync { lfo.bpmSync = bpmSync }
        lfos[index] = lfo
    }

    // MARK: - Knob Methods

    func setPerformanceKnobValue(_ knob: Int, _ value: Int) {
        performanceKnobs[knob] = max(0, min(127, value))
    }

    // MARK: - Macro Methods

    func setMacroValue(_ macro: Int, _ value: Int) {
        macroValues[macro] = max(0, min(127, value))
    }

    func assignMacroTarget(_ macro: Int, paramID: String, minScale: Int, maxScale: Int) {
        var assignments = macroAssignments[macro] ?? []
        if assignments.count < 2 {
            assignments.append((paramID: paramID, minScale: minScale, maxScale: maxScale))
            macroAssignments[macro] = assignments
        }
    }

    func unassignMacroTarget(_ macro: Int, _ index: Int) {
        guard var assignments = macroAssignments[macro], index < assignments.count else { return }
        assignments.remove(at: index)
        macroAssignments[macro] = assignments
    }

    // MARK: - XY Pad Methods

    func setXYPadPosition(_ point: CGPoint) {
        xyPadPosition = CGPoint(
            x: max(0, min(1, point.x)),
            y: max(0, min(1, point.y))
        )
    }

    func resetXYPad() {
        xyPadPosition = CGPoint(x: 0.5, y: 0.5)
    }

    // MARK: - Song Methods

    func addSongCurvePoint(_ track: String, _ point: CGPoint) {
        if songCurves[track] == nil {
            songCurves[track] = []
        }
        songCurves[track]?.append(point)
    }

    func clearSongCurve(_ track: String) {
        songCurves[track] = []
    }

    // MARK: - Field Methods

    func setFieldNodePosition(_ node: Int, _ position: CGPoint) {
        fieldNodes[node] = CGPoint(
            x: max(0, min(1, position.x)),
            y: max(0, min(1, position.y))
        )
    }

    func assignFieldNode(_ node: Int, paramID: String) {
        fieldAssignments[node] = paramID
    }
}

// MARK: - LFO Model

struct LFOModel: Codable {
    var enabled: Bool = false
    var waveform: String = "sine"
    var rate: Int = 64
    var depth: Int = 64
    var phase: Int = 0
    var bpmSync: Bool = false
    var assignments: [String] = []
}
