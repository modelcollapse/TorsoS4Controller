//
//  AppHeader.swift
//  Torso S4 Controller
//
//  Header bar with logo, transport, BPM, MIDI status, and snapshots
//

import SwiftUI

struct AppHeader: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 12) {
            // Logo
            Text("S4")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(width: 40, alignment: .center)

            Divider()
                .frame(height: 40)

            // Transport Controls
            TransportControls()

            Divider()
                .frame(height: 40)

            // BPM Display
            BPMDisplay()

            Divider()
                .frame(height: 40)

            // MIDI Status
            MIDIStatus()

            Spacer()

            // Snapshots (S1-S8)
            SnapshotRow()

            Divider()
                .frame(height: 40)

            // Settings button
            Button(action: {}) {
                Image(systemName: "gear")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)
            .padding(.trailing, 8)
        }
        .padding(.horizontal, 8)
        .background(DesignSystem.Colors.surface)
    }
}

// MARK: - Transport Controls

struct TransportControls: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            // Play button
            Button(action: { appState.isPlaying.toggle() }) {
                Image(systemName: appState.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)
            .background(appState.isPlaying ? DesignSystem.Colors.surfaceRaised : DesignSystem.Colors.surface)
            .cornerRadius(4)

            // Stop button
            Button(action: { appState.isPlaying = false }) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)

            // Panic button
            Button(action: {}) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.statusRed)
            }
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)
        }
    }
}

// MARK: - BPM Display

struct BPMDisplay: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 4) {
            // Minus button
            Button(action: { appState.bpm = max(20, appState.bpm - 1) }) {
                Image(systemName: "minus")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .buttonStyle(.plain)

            // BPM value
            Text("\(appState.bpm)")
                .font(DesignSystem.Typography.smallFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(width: 40, alignment: .center)

            // Plus button
            Button(action: { appState.bpm = min(300, appState.bpm + 1) }) {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - MIDI Status

struct MIDIStatus: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(appState.isMIDIConnected ? DesignSystem.Colors.statusGreen : DesignSystem.Colors.statusRed)
                .frame(width: 8, height: 8)

            Text(appState.isMIDIConnected ? "MIDI ON" : "MIDI OFF")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}

// MARK: - Snapshot Buttons

struct SnapshotRow: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...8, id: \.self) { slot in
                SnapshotButton(slot: slot)
            }
        }
    }
}

struct SnapshotButton: View {
    @EnvironmentObject var appState: AppState
    let slot: Int

    var body: some View {
        Button(action: {
            appState.loadSnapshot(slot)
        }) {
            Text("S\(slot)")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .buttonStyle(.plain)
        .frame(width: 32, height: 24)
        .background(DesignSystem.Colors.surfaceRaised)
        .cornerRadius(3)
        .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: DesignSystem.Colors.border)
    }
}

#Preview {
    AppHeader()
        .environmentObject(AppState())
        .frame(height: DesignSystem.Dimensions.headerHeight)
}
