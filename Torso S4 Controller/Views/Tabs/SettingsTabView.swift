//
//  SettingsTabView.swift
//  Torso S4 Controller
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsTabView: View {
    @EnvironmentObject var appState: AppState  // fixed

    @State private var presets: [PresetInfo] = []
    @State private var showingExportDialog = false
    @State private var exportName = ""
    @State private var showingImportFile = false
    @State private var showingConfirmClear = false
    @State private var selectedSettingsTab: SettingsSubTab = .general

    var body: some View {
        VStack(spacing: 0) {
            settingsSubTabBar

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    switch selectedSettingsTab {
                    case .general:
                        generalSection
                        safetySection

                    case .midi:
                        midiSection
                        midiTestSection

                    case .presets:
                        presetsSection

                    case .diagnostics:
                        diagnosticsSection

                    case .info:
                        infoSection
                    }
                }
                .padding(16)
            }
        }
        .background(DesignSystem.Colors.background)
        .onAppear { loadPresets() }
        .alert("Export Preset", isPresented: $showingExportDialog) {
            TextField("Preset name", text: $exportName)
            Button("Export") {
                let trimmed = exportName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    _ = appState.exportPreset(name: trimmed)
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

    // MARK: - SubTab Bar
    private var settingsSubTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SettingsSubTab.allCases, id: \.self) { tab in
                    Button(action: { selectedSettingsTab = tab }) {
                        Text(tab.rawValue)
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(
                                selectedSettingsTab == tab
                                ? DesignSystem.Colors.textPrimary
                                : DesignSystem.Colors.textSecondary
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                selectedSettingsTab == tab
                                ? DesignSystem.Colors.surface
                                : DesignSystem.Colors.surfaceRaised
                            )
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: DesignSystem.Colors.border)
                }
            }
            .padding(12)
        }
        .background(DesignSystem.Colors.surfaceRaised)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    // MARK: - Sections
    private var generalSection: some View { <truncated__content /> }
    private var midiSection: some View { <truncated__content /> }
    private var midiTestSection: some View { <truncated__content /> }
    private var safetySection: some View { <truncated__content /> }
    private var presetsSection: some View { <truncated__content /> }
    private var diagnosticsSection: some View { <truncated__content /> }
    private var infoSection: some View { <truncated__content /> }

    // MARK: - Helpers
    private func refreshMIDIDevices() { <truncated__content /> }
    private func loadPresets() { presets = appState.listPresets() }
    private func boolText(_ value: Bool) -> String { value ? "On" : "Off" }
}

enum SettingsSubTab: String, CaseIterable {
    case general = "General"
    case midi = "MIDI"
    case presets = "Presets"
    case diagnostics = "Diagnostics"
    case info = "Info"
}

#Preview {
    SettingsTabView().environmentObject(AppState())
}
