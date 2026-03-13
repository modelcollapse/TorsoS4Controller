//
//  ControlTabView.swift
//  Torso S4 Controller
//
//  Main synthesis parameter control tab
//

import SwiftUI

struct ControlTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Track selection row
            TrackToggleRow()
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            // Helper text
            Text("Drag knobs · Double-click reset · Shift+drag fine")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(8)
                .background(DesignSystem.Colors.surfaceRaised)
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            // Scrollable sections
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Constants.sections, id: \.self) { sectionID in
                        ControlSection(sectionID: sectionID)
                    }
                }
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

struct ControlSection: View {
    @EnvironmentObject var appState: AppState
    let sectionID: String

    private var sectionName: String {
        switch sectionID {
        case "disc": return "Disc"
        case "tape": return "Tape"
        case "poly": return "Poly"
        case "mosaic": return "Mosaic"
        case "ring": return "Ring"
        case "deform": return "Deform"
        case "vast": return "Vast"
        case "wave": return "Wave"
        case "adsr": return "ADSR"
        case "random": return "Random"
        case "waveModulator": return "Wave Modulator"
        case "mix": return "Mix"
        case "perform": return "Perform"
        case "sends": return "Sends"
        default: return sectionID
        }
    }

    private var parameters: [Constants.Parameter] {
        Constants.getParametersBySection(sectionID)
    }

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(sectionID: sectionID, sectionName: sectionName)

            if appState.expandedSections.contains(sectionID) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 8)],
                         spacing: 8) {
                    ForEach(parameters, id: \.id) { param in
                        ParameterControl(
                            parameter: param,
                            value: appState.getParameterValue(param.id),
                            onChange: { newValue in
                                appState.setParameterValue(param.id, newValue)
                            }
                        )
                    }
                }
                .padding(12)
                .background(DesignSystem.Colors.background)
            }
        }
    }
}

#Preview {
    ControlTabView()
        .environmentObject(AppState())
}
