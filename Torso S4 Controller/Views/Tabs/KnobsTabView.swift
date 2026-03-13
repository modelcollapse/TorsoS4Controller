//
//  KnobsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct KnobsTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Toggle("Record", isOn: $appState.isRecording)
                    .font(DesignSystem.Typography.smallFont)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .padding(12)
                Spacer()
            }
            .background(DesignSystem.Colors.surfaceRaised)
            .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)],
                         spacing: 16) {
                    ForEach(1...8, id: \.self) { knob in
                        PerformanceKnobCard(knobIndex: knob)
                    }
                }
                .padding(16)
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

struct PerformanceKnobCard: View {
    @EnvironmentObject var appState: AppState
    let knobIndex: Int

    var body: some View {
        VStack(spacing: 8) {
            KnobView(
                value: appState.performanceKnobs[knobIndex] ?? 64,
                onChange: { appState.setPerformanceKnobValue(knobIndex, $0) }
            )
            .frame(width: 80, height: 80)

            Text("K\(knobIndex)")
                .font(DesignSystem.Typography.regularFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}

#Preview {
    KnobsTabView()
        .environmentObject(AppState())
}
