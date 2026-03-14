//
//  SongTabView.swift
//  Torso S4 Controller
//
//  Song/Automation Tab - Multi-lane automation sequencer

import SwiftUI

struct SongTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLaneId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            songControlBar
            lanesList
        }
        .background(DesignSystem.Colors.background)
    }

    // MARK: - Control Bar (Top)
    private var songControlBar: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Text("SYNC RATE")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 65)

            Picker("Rate", selection: $appState.songSyncRate) {
                ForEach(["1/4", "1/8", "1/16", "1/32"], id: \.self) { rate in
                    Text(rate).tag(rate)
                }
            }
            .font(DesignSystem.Typography.body)
            .frame(width: 70)

            Divider().frame(height: 20)

            Text("DIR")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 30)

            Picker("Direction", selection: $appState.songDirection) {
                ForEach(["FWD", "REV", "P-P", "RAND"], id: \.self) { dir in
                    Text(dir).tag(dir)
                }
            }
            .font(DesignSystem.Typography.body)
            .frame(width: 70)

            Spacer()

            Button(action: { appState.addAutomationLane() }) {
                Text("+ TRACK")
                    .font(DesignSystem.Typography.label)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .frame(height: 24)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
            }
            .background(DesignSystem.Colors.surface)
            .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
            .contentShape(Rectangle())
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surfaceRaised)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    // MARK: - Lanes List
    private var lanesList: some View {
        ScrollView(.vertical) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                ForEach($appState.automationLanes) { $lane in
                    AutomationLaneCard(lane: $lane, isSelected: selectedLaneId == lane.id)
                        .onTapGesture {
                            selectedLaneId = lane.id
                        }
                }
            }
            .padding(DesignSystem.Spacing.md)
        }
    }
}

// MARK: - Automation Lane Card
struct AutomationLaneCard: View {
    @Binding var lane: AutomationLane
    let isSelected: Bool

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            // Lane Header with Parameter Assignment
            HStack(spacing: DesignSystem.Spacing.sm) {
                // Collapse/Expand
                Button(action: {}) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: 24, height: 24)
                }

                // Close Button
                Button(action: { /* Will be implemented by parent */ }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: 24, height: 24)
                }

                // Parameter Assignment Section
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Picker("Section", selection: $lane.parameterSection) {
                        ForEach(["Mix", "Disc", "Poly", "Mosaic", "Perform"], id: \.self) { section in
                            Text(section).tag(section)
                        }
                    }
                    .font(DesignSystem.Typography.body)
                    .frame(width: 70)

                    Text("·")
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Text("T\(lane.trackIndex + 1)")
                        .font(DesignSystem.Typography.label)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: 25)

                    Picker("Param", selection: $lane.parameter) {
                        ForEach(getParametersForSection(lane.parameterSection), id: \.self) { param in
                            Text(param).tag(param)
                        }
                    }
                    .font(DesignSystem.Typography.body)
                    .frame(width: 90)

                    Text("·")
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Text("CC\(lane.cc)")
                        .font(DesignSystem.Typography.label)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .frame(width: 40)

                    Spacer()
                }
            }

            // Visualization + Controls Row
            HStack(spacing: DesignSystem.Spacing.sm) {
                // Automation Visualization
                AutomationVisualization(data: $lane.automationData)
                    .frame(height: 80)
                    .background(DesignSystem.Colors.surfaceRaised)
                    .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                // Right Controls Column
                VStack(spacing: DesignSystem.Spacing.xs) {
                    // Top row: SYNC, LEN, RATE controls
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text("SYNC")
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .frame(width: 35)

                        Text("LEN")
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .frame(width: 32)

                        Text("\(lane.length)")
                            .font(DesignSystem.Typography.label)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(width: 28)

                        Text("RATE")
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .frame(width: 35)

                        Picker("Rate", selection: $lane.syncRate) {
                            ForEach(["1/4", "1/8", "1/16", "1/32"], id: \.self) { rate in
                                Text(rate).tag(rate)
                            }
                        }
                        .font(DesignSystem.Typography.body)
                        .frame(width: 65)
                    }

                    // Bottom row: DIR, FILL, Clear, MUTE
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text("DIR")
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .frame(width: 32)

                        Picker("Dir", selection: $lane.direction) {
                            ForEach(["FWD", "REV", "P-P", "RAND"], id: \.self) { dir in
                                Text(dir).tag(dir)
                            }
                        }
                        .font(DesignSystem.Typography.body)
                        .frame(width: 65)

                        Button("FILL") {
                            fillAutomationPattern()
                        }
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .frame(width: 45, height: 20)
                        .background(DesignSystem.Colors.surface)
                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
                        .contentShape(Rectangle())

                        Button("Clear") {
                            lane.automationData = Array(repeating: 64, count: 64)
                        }
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .frame(width: 45, height: 20)
                        .background(DesignSystem.Colors.surface)
                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
                        .contentShape(Rectangle())

                        Button(action: { lane.isMuted.toggle() }) {
                            Text(lane.isMuted ? "MUTE" : "MUTE")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(lane.isMuted ? DesignSystem.Colors.statusRed : DesignSystem.Colors.textPrimary)
                        }
                        .frame(width: 50, height: 20)
                        .background(lane.isMuted ? DesignSystem.Colors.surface : DesignSystem.Colors.background)
                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: lane.isMuted ? DesignSystem.Colors.statusRed : DesignSystem.Colors.border)
                        .contentShape(Rectangle())
                    }
                }
                .frame(width: 380)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .background(isSelected ? DesignSystem.Colors.surface : DesignSystem.Colors.background)
        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: isSelected ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.border)
    }

    private func getParametersForSection(_ section: String) -> [String] {
        let params: [String: [String]] = [
            "Mix": ["level", "filter", "pan", "compress", "output"],
            "Disc": ["speed", "tempo", "start", "length", "xfade"],
            "Poly": ["pitch", "start", "length", "level", "loop"],
            "Mosaic": ["pitch", "rate", "size", "spray", "wet"],
            "Perform": ["macro1", "macro2", "macro3", "macro4"]
        ]
        return params[section] ?? []
    }

    private func fillAutomationPattern() {
        // Create a simple sine wave pattern
        for i in 0..<lane.automationData.count {
            let normalized = Double(i) / Double(lane.automationData.count)
            let sineValue = sin(normalized * .pi * 4) // 2 cycles
            let scaled = Int(((sineValue + 1) / 2) * 127)
            lane.automationData[i] = max(0, min(127, scaled))
        }
    }
}

// MARK: - Automation Visualization
struct AutomationVisualization: View {
    @Binding var data: [Int]

    var body: some View {
        Canvas { context, size in
            let width = 580.0
            let height = 80.0
            let stepWidth = width / Double(data.count)

            // Draw background grid
            for i in 0..<data.count where i % 4 == 0 {
                let x = Double(i) * stepWidth
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
                context.stroke(
                    path,
                    with: .color(DesignSystem.Colors.border),
                    lineWidth: 0.5
                )
            }

            // Draw bars for each automation value
            for (index, value) in data.enumerated() {
                let x = Double(index) * stepWidth
                let barHeight = (Double(value) / 127.0) * (height - 4)
                let y = height - barHeight - 2

                let barRect = CGRect(
                    x: x + 1,
                    y: y,
                    width: stepWidth - 2,
                    height: barHeight
                )

                context.fill(
                    Path(roundedRect: barRect, cornerRadius: 0),
                    with: .color(DesignSystem.Colors.track1)
                )
            }

            // Draw center line (neutral position at 64)
            var centerPath = Path()
            centerPath.move(to: CGPoint(x: 0, y: height / 2))
            centerPath.addLine(to: CGPoint(x: width, y: height / 2))
            context.stroke(
                centerPath,
                with: .color(DesignSystem.Colors.textSecondary.opacity(0.3)),
                lineWidth: 0.5
            )
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    SongTabView()
        .environmentObject(AppState())
}
