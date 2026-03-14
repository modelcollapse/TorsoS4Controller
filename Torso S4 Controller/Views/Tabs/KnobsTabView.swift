//
//  KnobsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct KnobsTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var overdubMode: Bool = true
    @State private var syncToBPM: Bool = true
    @State private var quantizeGrid: String = "1/16"

    var body: some View {
        VStack(spacing: 0) {
            // Recording Controls
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    // Record Button with indicator
                    Button(action: { appState.isRecording.toggle() }) {
                        HStack(spacing: 6) {
                            if appState.isRecording {
                                Circle()
                                    .fill(DesignSystem.Colors.statusRed)
                                    .frame(width: 8, height: 8)
                            }
                            Text(appState.isRecording ? "Recording" : "Record")
                                .font(DesignSystem.Typography.smallFont)
                        }
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 12)
                    .background(appState.isRecording ? DesignSystem.Colors.statusRed.opacity(0.2) : DesignSystem.Colors.surface)
                    .foregroundColor(appState.isRecording ? DesignSystem.Colors.statusRed : DesignSystem.Colors.textPrimary)
                    .cornerRadius(3)

                    // Play Button
                    Button(action: { appState.isSequencerPlaying.toggle() }) {
                        Image(systemName: appState.isSequencerPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(width: 32, height: 32)
                    .background(DesignSystem.Colors.surface)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .cornerRadius(3)

                    // Stop Button
                    Button(action: { appState.isSequencerPlaying = false }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(width: 32, height: 32)
                    .background(DesignSystem.Colors.surface)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .cornerRadius(3)

                    Spacer()

                    // Overdub Toggle
                    Toggle("Overdub", isOn: $overdubMode)
                        .font(DesignSystem.Typography.labelFont)
                }

                // Quantization Settings
                HStack(spacing: 12) {
                    Toggle("Sync BPM", isOn: $syncToBPM)
                        .font(DesignSystem.Typography.smallFont)

                    if syncToBPM {
                        Text("Grid:")
                            .font(DesignSystem.Typography.labelFont)
                            .foregroundColor(DesignSystem.Colors.textSecondary)

                        Picker("", selection: $quantizeGrid) {
                            ForEach(["Off", "1/64", "1/32", "1/16", "1/8", "1/4", "1/2"], id: \.self) { value in
                                Text(value).tag(value)
                            }
                        }
                        .font(DesignSystem.Typography.labelFont)
                        .frame(maxWidth: 80)
                    }

                    Spacer()
                }
            }
            .padding(12)
            .background(DesignSystem.Colors.surfaceRaised)
            .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)],
                         spacing: 16) {
                    ForEach(1...8, id: \.self) { knob in
                        PerformanceKnobCard(knobIndex: knob)
                    }
                }
                .padding(16)
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

struct PerformanceKnobCard: View {
    @EnvironmentObject var appState: AppState
    let knobIndex: Int

    var body: some View {
        VStack(spacing: 8) {
            KnobView(
                value: appState.performanceKnobs[knobIndex] ?? 64,
                onChange: { appState.setPerformanceKnobValue(knobIndex, $0) }
            )
            .frame(width: 80, height: 80)

            Text("K\(knobIndex)")
                .font(DesignSystem.Typography.regularFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}

#Preview {
    KnobsTabView()
        .environmentObject(AppState())
}
