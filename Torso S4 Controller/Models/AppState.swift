//
//  AppState.swift
//  Torso S4 Controller
//
//  Global state management for the S4 MIDI Controller
//

import SwiftUI

// MARK: - Automation Lane Model
struct AutomationLane: Identifiable {
    let id: UUID = UUID()
    var parameterSection: String
    var parameter: String
    var cc: Int
    var trackIndex: Int = 0

    var automationData: [Int]
    var length: Int = 64
    var syncRate: String = "1/16"
    var direction: String = "FWD"
    var isMuted: Bool = false
}

enum TabSelection: String, CaseIterable {
    case blocks = "Components"
    case control = "Tracks"
    case sequencer = "Compose"
    case lfos = "Modulate"
    case knobs = "Knob Record"
    case macros = "Macros"
    case xypad = "XY Pad"
    case song = "Song"
    case field = "Spatial"
    case settings = "Settings"
}

@MainActor
class AppState: ObservableObject {
    @ObservedObject var midiManager = MIDIManager()
    @Published var selectedTab: TabSelection = .control
    @Published var bpm: Int = 120
    @Published var isPlaying: Bool = false
    @Published var isMIDIConnected: Bool = false

    @Published var parameterValues: [String: Int] = [:]
    @Published var snapshots: [Int: [String: Int]] = [:]
    @Published var lfoAssignments: [String: (lfoIndex: Int, depth: Int, enabled: Bool)] = [:]

    @Published var expandedSections: Set<String> = []
    @Published var activeTracks: Set<Int> = [1, 2, 3, 4]
    @Published var selectedTrackChannel: Int = 1

    // SEQUENCER
    @Published var sequencerTracks: [String: [Bool]] = [:]
    @Published var sequencerRate: Int = 64
    @Published var sequencerDirection: String = "FWD"
    @Published var isSequencerPlaying: Bool = false
    @Published var sequencerTrackSelection: String = ParameterDefaults.sequencerTrackSelection

    // LFOs
    @Published var lfos: [Int: LFOModel] = [:]

    // KNOBS
    @Published var performanceKnobs: [Int: Int] = [:]
    @Published var isRecording: Bool = false

    // MACROS
    @Published var macroValues: [Int: Int] = [:]
    @Published var macroAssignments: [Int: [(paramID: String, minScale: Int, maxScale: Int)]] = [:]

    // XY PAD
    @Published var xyPadPosition: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @Published var xyPadXAssignment: String = ParameterDefaults.xyPadXAssignment
    @Published var xyPadYAssignment: String = ParameterDefaults.xyPadYAssignment

    // SONG
    @Published var songLength: Int = 32
    @Published var songLoop: Bool = true
    @Published var songTarget: String = ParameterDefaults.songTarget
    @Published var songCurves: [String: [CGPoint]] = [:]
    @Published var songPlaybackPosition: CGFloat = 0
    @Published var automationLanes: [AutomationLane] = []
    @Published var songSyncRate: String = "1/16"
    @Published var songDirection: String = "FWD"

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
        initializeLFOs()
        initializeSongCurves()
        initializeAutomationLanes()
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
        let clamped = max(0, min(127, value))
        parameterValues[paramID] = clamped
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

        if (1...4).contains(track) {
            selectedTrackChannel = track
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

        fieldAssignments = ParameterDefaults.fieldNodeAssignments
    }

    private func initializeLFOs() {
        lfos[1] = LFOModel(enabled: true, waveform: "sine", rate: 60, depth: 64, phase: 0, bpmSync: true)
        lfos[2] = LFOModel(enabled: true, waveform: "square", rate: 48, depth: 48, phase: 32, bpmSync: true)
        lfos[3] = LFOModel(enabled: false, waveform: "triangle", rate: 80, depth: 32, phase: 64, bpmSync: false)
        lfos[4] = LFOModel(enabled: true, waveform: "saw", rate: 96, depth: 80, phase: 96, bpmSync: true)
    }

    private func initializeSongCurves() {
        var curve: [CGPoint] = []
        curve.append(CGPoint(x: 0.0, y: 0.3))
        curve.append(CGPoint(x: 0.25, y: 0.5))
        curve.append(CGPoint(x: 0.5, y: 0.7))
        curve.append(CGPoint(x: 0.75, y: 0.4))
        curve.append(CGPoint(x: 1.0, y: 0.6))
        songCurves["T1"] = curve
    }

    private func initializeAutomationLanes() {
        let defaultLane = AutomationLane(
            parameterSection: "Mix",
            parameter: "level",
            cc: 7,
            trackIndex: 0,
            automationData: Array(repeating: 64, count: 64),
            length: 64,
            syncRate: "1/16",
            direction: "FWD"
        )
        automationLanes.append(defaultLane)
    }

    func updateStep(track: String, step: Int, enabled: Bool) {
        if sequencerTracks[track] == nil {
            sequencerTracks[track] = Array(repeating: false, count: 16)
        }
        if step >= 0 && step < 16 {
            sequencerTracks[track]?[step] = enabled
        }
    }

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

    func setPerformanceKnobValue(_ knob: Int, _ value: Int) {
        performanceKnobs[knob] = max(0, min(127, value))
    }

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

    func setXYPadPosition(_ point: CGPoint) {
        xyPadPosition = CGPoint(
            x: max(0, min(1, point.x)),
            y: max(0, min(1, point.y))
        )
    }

    func resetXYPad() {
        xyPadPosition = CGPoint(x: 0.5, y: 0.5)
    }

    func addSongCurvePoint(_ track: String, _ point: CGPoint) {
        if songCurves[track] == nil {
            songCurves[track] = []
        }
        songCurves[track]?.append(point)
    }

    func clearSongCurve(_ track: String) {
        songCurves[track] = []
    }

    func addAutomationLane() {
        let newLane = AutomationLane(
            parameterSection: "Mix",
            parameter: "level",
            cc: 7,
            automationData: Array(repeating: 64, count: 64)
        )
        automationLanes.append(newLane)
    }

    func removeAutomationLane(_ id: UUID) {
        automationLanes.removeAll { $0.id == id }
    }

    func updateAutomationLaneValue(_ laneId: UUID, step: Int, value: Int) {
        if let index = automationLanes.firstIndex(where: { $0.id == laneId }),
           step >= 0, step < automationLanes[index].automationData.count {
            automationLanes[index].automationData[step] = max(0, min(127, value))
        }
    }

    func updateAutomationLane(_ laneId: UUID, section: String? = nil, parameter: String? = nil,
                              syncRate: String? = nil, direction: String? = nil, muted: Bool? = nil) {
        if let index = automationLanes.firstIndex(where: { $0.id == laneId }) {
            if let section = section { automationLanes[index].parameterSection = section }
            if let parameter = parameter { automationLanes[index].parameter = parameter }
            if let syncRate = syncRate { automationLanes[index].syncRate = syncRate }
            if let direction = direction { automationLanes[index].direction = direction }
            if let muted = muted { automationLanes[index].isMuted = muted }
        }
    }

    func clearAutomationLane(_ laneId: UUID) {
        if let index = automationLanes.firstIndex(where: { $0.id == laneId }) {
            automationLanes[index].automationData = Array(repeating: 64, count: 64)
        }
    }

    func setFieldNodePosition(_ node: Int, _ position: CGPoint) {
        fieldNodes[node] = CGPoint(
            x: max(0, min(1, position.x)),
            y: max(0, min(1, position.y))
        )
    }

    func assignFieldNode(_ node: Int, paramID: String) {
        fieldAssignments[node] = paramID
    }

    // MARK: - MIDI Test + Send

    func sendTestPlayStop() {
        guard let message = S4MIDITranslator.transportMessage(
            note: .playStop,
            velocity: 100,
            selectedTrackChannel: selectedTrackChannel
        ) else {
            print("Failed to create play/stop MIDI test message")
            return
        }

        midiManager.sendNoteOn(
            note: message.note,
            velocity: message.velocity,
            channel: message.channel
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.midiManager.sendNoteOff(
                note: message.note,
                velocity: 0,
                channel: message.channel
            )
        }

        print("Sent test note on/off: \(message.label) ch \(message.channel) note \(message.note)")
    }

    func sendTestMixLevel(_ value: Int = 100) {
        guard let message = S4MIDITranslator.mixMessage(
            parameter: .mainLevel,
            value: value,
            selectedTrackChannel: selectedTrackChannel
        ) else {
            print("Failed to create mix level MIDI test message")
            return
        }

        midiManager.sendControlChange(
            cc: message.cc,
            value: message.value,
            channel: message.channel
        )

        print("Sent test CC: \(message.label) ch \(message.channel) cc \(message.cc) value \(message.value)")
    }

    func sendParameter(_ paramID: String, _ value: Int) {
        setParameterValue(paramID, value)

        guard let parameter = Constants.getParameter(paramID) else {
            print("Parameter not found: \(paramID)")
            return
        }

        let message = S4MIDITranslator.message(
            for: parameter,
            value: value,
            selectedTrackChannel: selectedTrackChannel
        )

        midiManager.sendControlChange(
            cc: message.cc,
            value: message.value,
            channel: message.channel
        )

        print("Sent parameter: \(message.label) ch \(message.channel) cc \(message.cc) value \(message.value)")
    }

    // MARK: - Preset File I/O

    func exportPreset(name: String) -> URL? {
        let codableMacroAssignments = macroAssignments.mapValues { assignments in
            assignments.map { MacroAssignment(paramID: $0.paramID, minScale: $0.minScale, maxScale: $0.maxScale) }
        }

        let codableSongCurves = songCurves.mapValues { points in
            points.map { CodablePoint($0) }
        }

        let codableFieldNodes = fieldNodes.mapValues { CodablePoint($0) }

        let presetData = PresetData(
            parameterValues: parameterValues,
            sequencerTracks: sequencerTracks,
            sequencerRate: sequencerRate,
            sequencerDirection: sequencerDirection,
            lfos: lfos,
            performanceKnobs: performanceKnobs,
            macroValues: macroValues,
            macroAssignments: codableMacroAssignments,
            xyPadPosition: CodablePoint(xyPadPosition),
            xyPadXAssignment: xyPadXAssignment,
            xyPadYAssignment: xyPadYAssignment,
            songLength: songLength,
            songLoop: songLoop,
            songTarget: songTarget,
            songCurves: codableSongCurves,
            fieldNodes: codableFieldNodes,
            fieldAssignments: fieldAssignments,
            timestamp: Date()
        )

        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let s4Dir = documentsDir.appendingPathComponent("S4Presets", isDirectory: true)
        try? FileManager.default.createDirectory(at: s4Dir, withIntermediateDirectories: true)

        let filename = "\(name.replacingOccurrences(of: " ", with: "_")).s4"
        let presetURL = s4Dir.appendingPathComponent(filename)

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(presetData)
            try data.write(to: presetURL)
            return presetURL
        } catch {
            print("Error saving preset: \(error)")
            return nil
        }
    }

    func importPreset(from url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let presetData = try decoder.decode(PresetData.self, from: data)

            parameterValues = presetData.parameterValues
            sequencerTracks = presetData.sequencerTracks
            sequencerRate = presetData.sequencerRate
            sequencerDirection = presetData.sequencerDirection
            lfos = presetData.lfos
            performanceKnobs = presetData.performanceKnobs
            macroValues = presetData.macroValues

            macroAssignments = presetData.macroAssignments.mapValues { assignments in
                assignments.map { (paramID: $0.paramID, minScale: $0.minScale, maxScale: $0.maxScale) }
            }

            xyPadPosition = presetData.xyPadPosition.toCGPoint()
            xyPadXAssignment = presetData.xyPadXAssignment
            xyPadYAssignment = presetData.xyPadYAssignment
            songLength = presetData.songLength
            songLoop = presetData.songLoop
            songTarget = presetData.songTarget

            songCurves = presetData.songCurves.mapValues { points in
                points.map { $0.toCGPoint() }
            }

            fieldNodes = presetData.fieldNodes.mapValues { $0.toCGPoint() }
            fieldAssignments = presetData.fieldAssignments

            return true
        } catch {
            print("Error loading preset: \(error)")
            return false
        }
    }

    func listPresets() -> [PresetInfo] {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }

        let s4Dir = documentsDir.appendingPathComponent("S4Presets", isDirectory: true)

        guard let contents = try? FileManager.default.contentsOfDirectory(at: s4Dir, includingPropertiesForKeys: nil) else {
            return []
        }

        return contents
            .filter { $0.pathExtension == "s4" }
            .compactMap { url in
                let name = url.deletingPathExtension().lastPathComponent
                let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
                let modified = attrs?[.modificationDate] as? Date ?? Date()
                return PresetInfo(name: name, url: url, modified: modified)
            }
            .sorted { $0.modified > $1.modified }
    }

    func deletePreset(_ presetInfo: PresetInfo) -> Bool {
        do {
            try FileManager.default.removeItem(at: presetInfo.url)
            return true
        } catch {
            print("Error deleting preset: \(error)")
            return false
        }
    }

    func clearAllPresets() {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let s4Dir = documentsDir.appendingPathComponent("S4Presets", isDirectory: true)

        guard let contents = try? FileManager.default.contentsOfDirectory(at: s4Dir, includingPropertiesForKeys: nil) else {
            return
        }

        for url in contents {
            try? FileManager.default.removeItem(at: url)
        }
    }
}

struct CodablePoint: Codable {
    var x: Double
    var y: Double

    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    func toCGPoint() -> CGPoint {
        CGPoint(x: x, y: y)
    }
}

struct MacroAssignment: Codable {
    var paramID: String
    var minScale: Int
    var maxScale: Int
}

struct PresetData: Codable {
    var parameterValues: [String: Int]
    var sequencerTracks: [String: [Bool]]
    var sequencerRate: Int
    var sequencerDirection: String
    var lfos: [Int: LFOModel]
    var performanceKnobs: [Int: Int]
    var macroValues: [Int: Int]
    var macroAssignments: [Int: [MacroAssignment]]
    var xyPadPosition: CodablePoint
    var xyPadXAssignment: String
    var xyPadYAssignment: String
    var songLength: Int
    var songLoop: Bool
    var songTarget: String
    var songCurves: [String: [CodablePoint]]
    var fieldNodes: [Int: CodablePoint]
    var fieldAssignments: [Int: String]
    var timestamp: Date
}

struct PresetInfo: Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    var modified: Date
}

struct LFOModel: Codable {
    var enabled: Bool = false
    var waveform: String = "sine"
    var rate: Int = 64
    var depth: Int = 64
    var phase: Int = 0
    var bpmSync: Bool = false
    var assignments: [String] = []
}
