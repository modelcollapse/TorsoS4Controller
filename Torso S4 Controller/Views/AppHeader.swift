//
//  AppHeader.swift
//  Torso S4 Controller
//
//  Header bar with logo, transport, BPM, MIDI, presets, themes

import SwiftUI

struct AppHeader: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPreset = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Logo Section
                VStack(alignment: .leading, spacing: 2) {
                    Text("S4")
                        .font(DesignSystem.Typography.display)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    Text("Torso Electronics")
                        .font(DesignSystem.Typography.small)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .frame(width: 90, alignment: .leading)

                Divider().frame(height: 40)

                // Transport Controls
                TransportControls()

                Divider().frame(height: 40)

                // BPM Display
                BPMDisplay()

                Divider().frame(height: 40)

                // MIDI Status
                MIDIStatus()

                // MIDI Device Selectors
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Picker("Output", selection: $appState.midiOutputDevice) {
                        Text("— Output —").tag("")
                        Text("Device 1").tag("device1")
                        Text("Device 2").tag("device2")
                    }
                    .font(DesignSystem.Typography.label)
                    .frame(width: 100)

                    Picker("Input", selection: $appState.midiInputDevice) {
                        Text("— Input —").tag("")
                        Text("Device 1").tag("device1")
                        Text("Device 2").tag("device2")
                    }
                    .font(DesignSystem.Typography.label)
                    .frame(width: 100)
                }

                Divider().frame(height: 40)

                // Preset Controls
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Picker("Presets", selection: $selectedPreset) {
                        Text("— Presets —").tag("")
                    }
                    .font(DesignSystem.Typography.label)
                    .frame(width: 100)

                    Button(action: {}) {
                        Text("Load")
                            .font(DesignSystem.Typography.label)
                    }
                    .buttonStyle(HeaderButtonStyle())

                    Button(action: {}) {
                        Text("Save")
                            .font(DesignSystem.Typography.label)
                    }
                    .buttonStyle(HeaderButtonStyle())

                    Button(action: {}) {
                        Text("Export")
                            .font(DesignSystem.Typography.label)
                    }
                    .buttonStyle(HeaderButtonStyle())

                    Button(action: {}) {
                        Text("Import")
                            .font(DesignSystem.Typography.label)
                    }
                    .buttonStyle(HeaderButtonStyle())
                }

                Divider().frame(height: 40)

                // Snapshots
                SnapshotRow()

                Divider().frame(height: 40)

                // Theme Selector
                HStack(spacing: DesignSystem.Spacing.xs) {
                    ForEach(["☾", "☀", "🌿", "🌈"], id: \.self) { theme in
                        Button(action: {}) {
                            Text(theme)
                                .font(DesignSystem.Typography.body)
                        }
                        .buttonStyle(HeaderButtonStyle())
                        .frame(width: 24, height: 24)
                    }
                }

                Divider().frame(height: 40)

                // Utilities
                Button(action: {}) {
                    Text("Monitor")
                        .font(DesignSystem.Typography.label)
                }
                .buttonStyle(HeaderButtonStyle())

                Button(action: {}) {
                    Text("Hints")
                        .font(DesignSystem.Typography.label)
                }
                .buttonStyle(HeaderButtonStyle())

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(DesignSystem.Colors.surface)
        }
    }
}

// MARK: - Header Button Style

struct HeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(DesignSystem.Colors.textPrimary)
            .frame(height: 24)
            .padding(.horizontal, DesignSystem.Spacing.xs)
            .background(DesignSystem.Colors.surfaceRaised)
            .cornerRadius(3)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.05), value: configuration.isPressed)
    }
}

// MARK: - Transport Controls

struct TransportControls: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Button(action: { appState.isPlaying.toggle() }) {
                Image(systemName: appState.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .frame(width: 24, height: 24)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .buttonStyle(HeaderButtonStyle())

            Button(action: { appState.isPlaying = false }) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .frame(width: 24, height: 24)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
            .buttonStyle(HeaderButtonStyle())

            Button(action: {}) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 9, weight: .semibold))
                    .frame(width: 24, height: 24)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .buttonStyle(HeaderButtonStyle())

            Button(action: {}) {
                Text("!")
                    .font(.system(size: 12, weight: .bold))
                    .frame(width: 24, height: 24)
                    .foregroundColor(DesignSystem.Colors.statusRed)
            }
            .buttonStyle(HeaderButtonStyle())
        }
    }
}

// MARK: - BPM Display

struct BPMDisplay: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Text("BPM")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            TextField("120", value: $appState.bpm, format: .number)
                .font(DesignSystem.Typography.label)
                .frame(width: 40)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - MIDI Status

struct MIDIStatus: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Circle()
                .fill(appState.isMIDIConnected ? DesignSystem.Colors.statusGreen : DesignSystem.Colors.statusRed)
                .frame(width: 6, height: 6)

            Text(appState.isMIDIConnected ? "Connected" : "No MIDI")
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}

// MARK: - Snapshot Buttons

struct SnapshotRow: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xs) {
            Text("Snapshot")
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textSecondary)

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
                .font(DesignSystem.Typography.label)
                .frame(width: 22, height: 20)
        }
        .buttonStyle(HeaderButtonStyle())
    }
}

#Preview {
    AppHeader()
        .environmentObject(AppState())
        .frame(height: DesignSystem.Dimensions.headerHeight)
}
