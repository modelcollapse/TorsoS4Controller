//
//  MacrosTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct MacrosTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 12)],
                     spacing: 12) {
                ForEach(1...16, id: \.self) { macro in
                    MacroCard(macroIndex: macro)
                }
            }
            .padding(16)
        }
        .background(DesignSystem.Colors.background)
    }
}

struct MacroCard: View {
    @EnvironmentObject var appState: AppState
    let macroIndex: Int
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 12) {
            KnobView(
                value: appState.macroValues[macroIndex] ?? 64,
                onChange: { appState.setMacroValue(macroIndex, $0) }
            )
            .frame(width: 80, height: 80)

            Text("M\(macroIndex)")
                .font(DesignSystem.Typography.regularFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            if !(appState.macroAssignments[macroIndex] ?? []).isEmpty {
                VStack(spacing: 6) {
                    ForEach((appState.macroAssignments[macroIndex] ?? []).indices, id: \.self) { idx in
                        let assignment = (appState.macroAssignments[macroIndex] ?? [])[idx]

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(Constants.getParameter(assignment.paramID)?.name ?? "Unknown")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .lineLimit(1)
                                Spacer()
                                Text("[\(assignment.minScale)–\(assignment.maxScale)]")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.track1)
                            }

                            // Min/Max Range Slider
                            HStack(spacing: 8) {
                                Text("Min")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .frame(width: 24)

                                Slider(
                                    value: .init(
                                        get: { Double(assignment.minScale) },
                                        set: { newMin in
                                            var assignments = appState.macroAssignments[macroIndex] ?? []
                                            if idx < assignments.count {
                                                assignments[idx].minScale = Int(newMin)
                                                appState.macroAssignments[macroIndex] = assignments
                                            }
                                        }
                                    ),
                                    in: 0...127
                                )

                                Text("\(assignment.minScale)")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 28)
                            }

                            HStack(spacing: 8) {
                                Text("Max")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .frame(width: 24)

                                Slider(
                                    value: .init(
                                        get: { Double(assignment.maxScale) },
                                        set: { newMax in
                                            var assignments = appState.macroAssignments[macroIndex] ?? []
                                            if idx < assignments.count {
                                                assignments[idx].maxScale = Int(newMax)
                                                appState.macroAssignments[macroIndex] = assignments
                                            }
                                        }
                                    ),
                                    in: 0...127
                                )

                                Text("\(assignment.maxScale)")
                                    .font(DesignSystem.Typography.labelFont)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 28)
                            }
                        }
                        .padding(6)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(3)
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("No targets assigned")
                    .font(DesignSystem.Typography.labelFont)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(12)
        .background(DesignSystem.Colors.surfaceRaised)
        .cornerRadius(6)
    }
}

#Preview {
    MacrosTabView()
        .environmentObject(AppState())
}
