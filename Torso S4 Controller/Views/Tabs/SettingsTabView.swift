//
//  SettingsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SettingsTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SettingsSection(title: "Theme") {
                    HStack(spacing: 8) {
                        ForEach(["dark", "light", "natural"], id: \.self) { theme in
                            Button(action: { appState.themeMode = theme }) {
                                Text(theme.capitalized)
                                    .font(DesignSystem.Typography.smallFont)
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
                    VStack(spacing: 8) {
                        HStack {
                            Text("Output:")
                                .font(DesignSystem.Typography.smallFont)
                            Text(appState.midiOutputDevice)
                                .font(DesignSystem.Typography.labelFont)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Spacer()
                        }

                        HStack {
                            Circle()
                                .fill(
                                    appState.isMIDIConnected ?
                                    DesignSystem.Colors.statusGreen :
                                    DesignSystem.Colors.statusRed
                                )
                                .frame(width: 8, height: 8)
                            Text(appState.isMIDIConnected ? "Connected" : "Disconnected")
                                .font(DesignSystem.Typography.smallFont)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Spacer()
                        }
                    }
                }

                SettingsSection(title: "Safety") {
                    VStack(spacing: 8) {
                        Toggle("Protect MIX", isOn: $appState.protectMix)
                        Toggle("All Sound Off on Panic", isOn: $appState.allSoundOffOnPanic)
                        Toggle("Reset CC on Startup", isOn: $appState.resetCCOnStartup)
                    }
                    .font(DesignSystem.Typography.smallFont)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                }

                SettingsSection(title: "Info") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Version:")
                                .font(DesignSystem.Typography.smallFont)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Text("1.0.0")
                                .font(DesignSystem.Typography.smallFont)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }
                        HStack {
                            Text("Build:")
                                .font(DesignSystem.Typography.smallFont)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Text("2026-03-13")
                                .font(DesignSystem.Typography.smallFont)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(DesignSystem.Colors.background)
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
                .font(DesignSystem.Typography.regularFont)
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
