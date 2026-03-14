//
//  SettingsTabView.swift
//  Torso S4 Controller
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsTabView: View {
    @EnvironmentObject var appState: AppState  // fixed placeholder

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
    }

    private var settingsSubTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SettingsSubTab.allCases, id: \.self) { tab in
                    let isSelected = selectedSettingsTab == tab
                    Button(action: { selectedSettingsTab = tab }) {
                        Text(tab.rawValue)
                            .font(DesignSystem.Typography.small)
                            .foregroundColor(isSelected ? DesignSystem.Colors.textPrimary : DesignSystem.Colors.textSecondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(isSelected ? DesignSystem.Colors.surface : DesignSystem.Colors.surfaceRaised)
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

    // Sections placeholders
    private var generalSection: some View { <truncated__content /> }
    private var midiSection: some View { <truncated__content /> }
    private var midiTestSection: some View { <truncated__content /> }
    private var safetySection: some View { <truncated__content /> }
    private var presetsSection: some View { <truncated__content /> }
    private var diagnosticsSection: some View { <truncated__content /> }
    private var infoSection: some View { <truncated__content /> }

    private func loadPresets() { presets = appState.listPresets() }
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
