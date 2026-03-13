//
//  SequencerTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SequencerTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            SequencerControls()
                .padding(12)
                .background(DesignSystem.Colors.surfaceRaised)
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            Text("16 tracks · 16 steps")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DesignSystem.Colors.surface)

            ScrollView([.horizontal, .vertical]) {
                SequencerGrid()
                    .padding(12)
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

struct SequencerControls: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Button(action: { appState.isSequencerPlaying.toggle() }) {
                    Image(systemName: appState.isSequencerPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                .frame(width: 32, height: 32)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(3)

                Button(action: { appState.isSequencerPlaying = false }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                .frame(width: 32, height: 32)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(3)

                Divider()
                    .frame(height: 24)

                Text("Rate:")
                    .font(DesignSystem.Typography.smallFont)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Slider(value: .init(
                    get: { Double(appState.sequencerRate) },
                    set: { appState.sequencerRate = Int($0) }
                ), in: 0...127)
                .frame(width: 100)

                Text("\(appState.sequencerRate)")
                    .font(DesignSystem.Typography.labelFont)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .frame(width: 30, alignment: .trailing)

                Spacer()
            }

            HStack(spacing: 8) {
                Text("Direction:")
                    .font(DesignSystem.Typography.smallFont)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                ForEach(["FWD", "REV", "P-P", "RAND"], id: \.self) { dir in
                    Button(action: { appState.sequencerDirection = dir }) {
                        Text(dir)
                            .font(DesignSystem.Typography.labelFont)
                            .foregroundColor(
                                appState.sequencerDirection == dir ?
                                DesignSystem.Colors.textPrimary :
                                DesignSystem.Colors.textSecondary
                            )
                    }
                    .frame(height: 24)
                    .padding(.horizontal, 6)
                    .background(
                        appState.sequencerDirection == dir ?
                        DesignSystem.Colors.surface :
                        DesignSystem.Colors.background
                    )
                    .cornerRadius(3)
                }

                Spacer()
            }
        }
    }
}

struct SequencerGrid: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(40), spacing: 2), count: 16),
                 spacing: 2) {
            ForEach(0..<256, id: \.self) { index in
                let track = index / 16
                let step = index % 16
                let trackKey = Constants.parameters[track].id

                Button(action: {
                    let current = appState.sequencerTracks[trackKey]?[step] ?? false
                    appState.updateStep(track: trackKey, step: step, enabled: !current)
                }) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            (appState.sequencerTracks[trackKey]?[step] ?? false) ?
                            DesignSystem.Colors.track1 :
                            DesignSystem.Colors.surfaceRaised
                        )
                }
                .frame(height: 40)
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    SequencerTabView()
        .environmentObject(AppState())
}
