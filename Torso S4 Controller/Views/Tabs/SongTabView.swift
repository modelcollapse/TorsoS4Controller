//
//  SongTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SongTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Text("Length:")
                        .font(DesignSystem.Typography.smallFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    TextField("Bars", value: $appState.songLength, format: .number)
                        .font(DesignSystem.Typography.smallFont)
                        .frame(width: 60)
                        .textFieldStyle(.roundedBorder)

                    Text("bars")
                        .font(DesignSystem.Typography.smallFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Toggle("Loop", isOn: $appState.songLoop)
                        .font(DesignSystem.Typography.smallFont)

                    Spacer()

                    Button(action: {
                        appState.clearSongCurve("T1")
                        appState.clearSongCurve("T2")
                        appState.clearSongCurve("T3")
                        appState.clearSongCurve("T4")
                    }) {
                        Text("Clear")
                            .font(DesignSystem.Typography.smallFont)
                    }
                    .frame(height: 28)
                    .padding(.horizontal, 12)
                    .background(DesignSystem.Colors.surfaceRaised)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .cornerRadius(3)
                }

                HStack(spacing: 12) {
                    Text("Target:")
                        .font(DesignSystem.Typography.smallFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Picker("", selection: $appState.songTarget) {
                        ForEach(Constants.parameters, id: \.id) { param in
                            Text(param.name).tag(param.id)
                        }
                    }
                    .font(DesignSystem.Typography.smallFont)

                    Spacer()
                }
            }
            .padding(12)
            .background(DesignSystem.Colors.surfaceRaised)
            .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(["T1", "T2", "T3", "T4"], id: \.self) { track in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(track)
                                .font(DesignSystem.Typography.labelFont)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .padding(.horizontal, 12)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(DesignSystem.Colors.surface)
                                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
                                .frame(height: 60)
                        }
                    }
                }
                .padding(12)
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    SongTabView()
        .environmentObject(AppState())
}
