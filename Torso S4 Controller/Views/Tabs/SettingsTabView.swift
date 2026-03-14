//
//  SettingsTabView.swift
//  Torso S4 Controller
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var presets: [PresetInfo] = []
    @State private var showingExportDialog = false
    @State private var exportName = ""
    @State private var showingImportFile = false
    @State private var showingConfirmClear = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SettingsSection(title: "Theme") {
                    HStack(spacing: 8) {
                        ForEach(["dark", "light", "natural"], id: \.self) { theme in
                            Button(action: { appState.themeMode = theme }) {
                                Text(theme.capitalized)
                                    .font(DesignSystem.Typography.small)
                                    .foregroundColor(
                                        appState.themeMode == theme ?
                                        DesignSystem.Colors.textPrimary :
                                        DesignSystem.Colors.textSecondary
                                    )
                            }
                            .frame(height: 28)
                            .padding(.horizontal, 12)
                            .background(
                                appState.themeMode == theme ?
                                DesignSystem.Colors.surface :
                                DesignSystem.Colors.surfaceRaised
                            )
                            .cornerRadius(3)
                        }
                        Spacer()
                    }
                }

                SettingsSection(title: "MIDI") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Selected Output:")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textSecondary)

                            Text(appState.midiManager.selectedOutputName)
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary)

                            Spacer()
                        }

                        HStack {
                            Circle()
                                .fill(
                                    appState.midiManager.isConnected ?
                                    DesignSystem.Colors.statusGreen :
                                    DesignSystem.Colors.statusRed
                                )
                                .frame(width: 8, height: 8)

                            Text(appState.midiManager.isConnected ? "Connected" : "Disconnected")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textSecondary)

                            Spacer()
                        }

                        if !appState.midiManager.outputDevices.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Available Outputs")
                                    .font(DesignSystem.Typography.small)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)

                                ForEach(appState.midiManager.outputDevices) { device in
                                    Button(action: {
                                        appState.midiManager.selectOutputDevice(id: device.id)
                                        appState.midiOutputDevice = device.name
                                        appState.isMIDIConnected = appState.midiManager.isConnected
                                    }) {
                                        HStack {
                                            Text(device.name)
                                                .font(DesignSystem.Typography.body)
                                                .foregroundColor(DesignSystem.Colors.textPrimary)

                                            Spacer()

                                            if appState.midiManager.selectedOutputID == device.id {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(DesignSystem.Colors.statusGreen)
                                            }
                                        }
                                        .padding(8)
                                        .background(DesignSystem.Colors.surface)
                                        .cornerRadius(3)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Button(action: {
                            appState.midiManager.updateDeviceList()
                            appState.midiOutputDevice = appState.midiManager.selectedOutputName
                            appState.isMIDIConnected = appState.midiManager.isConnected
                        }) {
                            Text("Refresh MIDI Devices")
                                .font(DesignSystem.Typography.small)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 32)
                        .background(DesignSystem.Colors.surfaceRaised)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .cornerRadius(3)
                    }
                }

                SettingsSection(title: "MIDI Tests") {
                    VStack(spacing: 8) {
                        Button(action: {
                            appState.sendTestPlayStop()
                        }) {
                            Text("Send Play/Stop Test")
                                .font(DesignSystem.Typography.small)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 32)
                        .background(DesignSystem.Colors.surfaceRaised)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .cornerRadius(3)

                        Button(action: {
                            appState.sendTestMixLevel(100)
                        }) {
                            Text("Send Mix Level Test")
                                .font(DesignSystem.Typography.small)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 32)
                        .background(DesignSystem.Colors.surfaceRaised)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .cornerRadius(3)
                    }
                }

                SettingsSection(title: "Safety") {
                    VStack(spacing: 8) {
                        Toggle("Protect MIX", isOn: $appState.protectMix)
                        Toggle("All Sound Off on Panic", isOn: $appState.allSoundOffOnPanic)
                        Toggle("Reset CC on Startup", isOn: $appState.resetCCOnStartup)
                    }
                    .font(DesignSystem.Typography.small)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                }

                SettingsSection(title: "Presets") {
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Button(action: { showingExportDialog = true }) {
                                Text("Export")
                                    .font(DesignSystem.Typography.small)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: 32)
                            .background(DesignSystem.Colors.surfaceRaised)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .cornerRadius(3)

                            Button(action: { showingImportFile = true }) {
                                Text("Import")
                                    .font(DesignSystem.Typography.small)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: 32)
                            .background(DesignSystem.Colors.surfaceRaised)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .cornerRadius(3)

                            Button(action: { showingConfirmClear = true }) {
                                Text("Clear All")
                                    .font(DesignSystem.Typography.small)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: 32)
                            .background(DesignSystem.Colors.statusRed.opacity(0.2))
                            .foregroundColor(DesignSystem.Colors.statusRed)
                            .cornerRadius(3)
                        }

                        if !presets.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Saved Presets:")
                                    .font(DesignSystem.Typography.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)

                                ForEach(presets) { preset in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(preset.name)
                                                .font(DesignSystem.Typography.small)
                                                .foregroundColor(DesignSystem.Colors.textPrimary)

                                            Text(preset.modified.formatted(date: .abbreviated, time: .shortened))
                                                .font(DesignSystem.Typography.body)
                                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                        }

                                        Spacer()

                                        Button(action: {
                                            if appState.importPreset(from: preset.url) {
                                                loadPresets()
                                            }
                                        }) {
                                            Text("Load")
                                                .font(DesignSystem.Typography.body)
                                                .foregroundColor(DesignSystem.Colors.track1)
                                        }
                                        .buttonStyle(.plain)

                                        Button(action: {
                                            _ = appState.deletePreset(preset)
                                            loadPresets()
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 12))
                                                .foregroundColor(DesignSystem.Colors.statusRed)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(8)
                                    .background(DesignSystem.Colors.surface)
                                    .cornerRadius(3)
                                }
                            }
                        }
                    }
                }

                SettingsSection(title: "Info") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Version:")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textSecondary)

                            Text("1.0.0")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }

                        HStack {
                            Text("Build:")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textSecondary)

                            Text("2026-03-13")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(DesignSystem.Colors.background)
        .onAppear {
            loadPresets()
            appState.midiManager.updateDeviceList()
            appState.midiOutputDevice = appState.midiManager.selectedOutputName
            appState.isMIDIConnected = appState.midiManager.isConnected
        }
        .alert("Export Preset", isPresented: $showingExportDialog) {
            TextField("Preset name", text: $exportName)

            Button("Export") {
                if !exportName.isEmpty {
                    _ = appState.exportPreset(name: exportName)
                    exportName = ""
                    loadPresets()
                }
            }

            Button("Cancel", role: .cancel) { }
        }
        .fileImporter(
            isPresented: $showingImportFile,
            allowedContentTypes: [UTType(filenameExtension: "s4")!],
            onCompletion: { result in
                switch result {
                case .success(let url):
                    _ = appState.importPreset(from: url)
                    loadPresets()

                case .failure:
                    break
                }
            }
        )
        .alert("Clear All Presets?", isPresented: $showingConfirmClear) {
            Button("Clear", role: .destructive) {
                appState.clearAllPresets()
                loadPresets()
            }

            Button("Cancel", role: .cancel) { }
        }
    }

    private func loadPresets() {
        presets = appState.listPresets()
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(.bottom, 4)

            content
        }
    }
}

#Preview {
    SettingsTabView()
        .environmentObject(AppState())
}
