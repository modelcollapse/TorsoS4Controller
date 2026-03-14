//
//  SequencerTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SequencerTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: String = "mix"
    @State private var selectedParam: String = "mix_level"
    @State private var selectedTrack: Int = 0

    private let directionOptions = ["FWD", "REV", "P-P", "RAND"]

    private var assignableSections: [String] {
        Constants.sections.filter { !Constants.getParametersBySection($0).isEmpty }
    }

    private var parametersForSelectedSection: [Constants.Parameter] {
        Constants.getParametersBySection(selectedSection)
    }

    var body: some View {
        VStack(spacing: 0) {
            controlsSection
            gridInfoSection
            gridSection
        }
        .background(DesignSystem.Colors.background)
        .onAppear {
            normalizeSelection()
        }
        .onChange(of: selectedSection) { _ in
            normalizeSelection()
        }
    }

    private var controlsSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            transportRow
            directionRow
            assignmentRow
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surfaceRaised)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    private var transportRow: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.lg) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                transportButton(
                    systemImage: appState.isSequencerPlaying ? "pause.fill" : "play.fill",
                    action: { appState.isSequencerPlaying.toggle() }
                )

                transportButton(
                    systemImage: "stop.fill",
                    action: { appState.isSequencerPlaying = false }
                )
            }

            Divider().frame(height: 52)

            CompactKnobView(
                label: "RATE",
                value: appState.sequencerRate,
                onChange: { appState.sequencerRate = $0 }
            )

            VStack(alignment: .leading, spacing: 6) {
                Text("CURRENT RATE")
                    .font(DesignSystem.Typography.small)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Text("\(appState.sequencerRate)")
                    .font(DesignSystem.Typography.display)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .monospacedDigit()

                Text("Double-click knob to reset")
                    .font(DesignSystem.Typography.small)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            Spacer()
        }
    }

    private func transportButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .semibold))
                .frame(width: 28, height: 28)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .buttonStyle(.plain)
        .background(DesignSystem.Colors.surface)
        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
        .contentShape(Rectangle())
    }

    private var directionRow: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Text("DIR")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 30)

            ForEach(directionOptions, id: \.self) { dir in
                Button(action: { appState.sequencerDirection = dir }) {
                    Text(dir)
                        .font(DesignSystem.Typography.label)
                        .foregroundColor(
                            appState.sequencerDirection == dir ?
                            DesignSystem.Colors.textPrimary :
                            DesignSystem.Colors.textSecondary
                        )
                        .frame(height: 24)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                }
                .buttonStyle(.plain)
                .background(
                    appState.sequencerDirection == dir ?
                    DesignSystem.Colors.surface :
                    DesignSystem.Colors.background
                )
                .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
                .contentShape(Rectangle())
            }

            Spacer()
        }
    }

    private var assignmentRow: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
            Text("ASSIGN")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Picker("Section", selection: $selectedSection) {
                ForEach(assignableSections, id: \.self) { sectionID in
                    Text(sectionDisplayName(sectionID)).tag(sectionID)
                }
            }
            .font(DesignSystem.Typography.body)
            .frame(width: 110)

            Picker("Param", selection: $selectedParam) {
                ForEach(parametersForSelectedSection, id: \.id) { param in
                    Text(param.name).tag(param.id)
                }
            }
            .font(DesignSystem.Typography.body)
            .frame(width: 130)

            Picker("Track", selection: $selectedTrack) {
                ForEach(0..<4, id: \.self) { track in
                    Text("T\(track + 1)").tag(track)
                }
            }
            .font(DesignSystem.Typography.body)
            .frame(width: 70)

            Spacer()
        }
    }

    private var gridInfoSection: some View {
        HStack {
            Text("16 TRACKS × 16 STEPS")
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Spacer()

            Text("\(sectionDisplayName(selectedSection).uppercased()) · \(parameterDisplayName(selectedParam).uppercased()) · T\(selectedTrack + 1)")
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .monospacedDigit()
        }
        .padding(DesignSystem.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.surface)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    private var gridSection: some View {
        ScrollView([.horizontal, .vertical]) {
            SequencerGrid(selectedTrack: selectedTrack)
                .padding(DesignSystem.Spacing.md)
        }
        .background(DesignSystem.Colors.background)
    }

    private func normalizeSelection() {
        if !assignableSections.contains(selectedSection) {
            selectedSection = assignableSections.first ?? "mix"
        }

        let validParams = parametersForSelectedSection.map(\.id)
        if !validParams.contains(selectedParam) {
            selectedParam = validParams.first ?? ""
        }

        if !selectedParam.isEmpty {
            appState.sequencerTrackSelection = selectedParam
        }
    }

    private func sectionDisplayName(_ sectionID: String) -> String {
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

    private func parameterDisplayName(_ paramID: String) -> String {
        Constants.getParameter(paramID)?.name ?? paramID
    }
}

struct SequencerGrid: View {
    @EnvironmentObject var appState: AppState
    let selectedTrack: Int
    @State private var hoveredStep: (track: Int, step: Int)? = nil

    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                Rectangle()
                    .fill(DesignSystem.Colors.surfaceRaised)
                    .frame(width: 60, height: 32)

                ForEach(1...16, id: \.self) { step in
                    Text("\(step)")
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: 40, height: 32)
                        .background(DesignSystem.Colors.surfaceRaised)
                        .border(width: 1, edges: [.trailing, .bottom], color: DesignSystem.Colors.border)
                }
            }

            ForEach(0..<16, id: \.self) { trackIdx in
                HStack(spacing: 1) {
                    Text("T\(trackIdx + 1)")
                        .font(DesignSystem.Typography.label)
                        .foregroundColor(trackIdx == selectedTrack ? DesignSystem.Colors.textPrimary : DesignSystem.Colors.textSecondary)
                        .frame(width: 60, height: 40)
                        .background(trackIdx == selectedTrack ? DesignSystem.Colors.surfaceRaised : DesignSystem.Colors.surface)
                        .border(width: 1, edges: [.trailing, .bottom], color: DesignSystem.Colors.border)

                    ForEach(0..<16, id: \.self) { step in
                        let trackKey = trackKey(for: trackIdx)
                        let isActive = appState.sequencerTracks[trackKey]?[step] ?? false
                        let isHovered = hoveredStep?.track == trackIdx && hoveredStep?.step == step

                        Button(action: {
                            appState.updateStep(track: trackKey, step: step, enabled: !isActive)
                        }) {
                            Rectangle()
                                .fill(isActive ? getTrackColor(trackIdx) : DesignSystem.Colors.surfaceRaised)
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(
                                            borderColor(trackIdx: trackIdx, isHovered: isHovered),
                                            lineWidth: borderWidth(trackIdx: trackIdx, isHovered: isHovered)
                                        )
                                )
                        }
                        .frame(width: 40, height: 40)
                        .buttonStyle(.plain)
                        .border(width: 1, edges: [.trailing, .bottom], color: DesignSystem.Colors.border)
                        .onHover { hovering in
                            hoveredStep = hovering ? (track: trackIdx, step: step) : nil
                        }
                    }
                }
            }
        }
    }

    private func trackKey(for trackIdx: Int) -> String {
        let available = Constants.parameters.indices.contains(trackIdx) ? Constants.parameters[trackIdx].id : "track_\(trackIdx + 1)"
        return available
    }

    private func borderColor(trackIdx: Int, isHovered: Bool) -> Color {
        if isHovered {
            return DesignSystem.Colors.textSecondary
        }
        if trackIdx == selectedTrack {
            return getTrackColor(trackIdx)
        }
        return DesignSystem.Colors.border
    }

    private func borderWidth(trackIdx: Int, isHovered: Bool) -> CGFloat {
        if isHovered {
            return 1
        }
        if trackIdx == selectedTrack {
            return 1
        }
        return 0.5
    }

    private func getTrackColor(_ trackIdx: Int) -> Color {
        switch trackIdx % 4 {
        case 0: return DesignSystem.Colors.track1
        case 1: return DesignSystem.Colors.track2
        case 2: return DesignSystem.Colors.track3
        case 3: return DesignSystem.Colors.track4
        default: return DesignSystem.Colors.track1
        }
    }
}

#Preview {
    SequencerTabView()
        .environmentObject(AppState())
}
