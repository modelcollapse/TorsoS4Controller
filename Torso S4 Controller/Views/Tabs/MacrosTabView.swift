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
                VStack(spacing: 4) {
                    ForEach((appState.macroAssignments[macroIndex] ?? []).indices, id: \.self) { idx in
                        let assignment = (appState.macroAssignments[macroIndex] ?? [])[idx]
                        Text(Constants.getParameter(assignment.paramID)?.name ?? "Unknown")
                            .font(DesignSystem.Typography.labelFont)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity)
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
