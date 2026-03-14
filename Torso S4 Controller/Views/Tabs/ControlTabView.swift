//
//  ControlTabView.swift
//  Torso S4 Controller
//
//  Main parameter control tab
//

import SwiftUI

struct ControlTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: String = "disc"

    private let parameterColumns = [
        GridItem(.adaptive(minimum: 96), spacing: 10, alignment: .top)
    ]

    private var availableSections: [String] {
        ParameterRegistry.sectionIDsWithParameters()
    }

    var body: some View {
        VStack(spacing: 0) {
            TrackToggleRow()
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            sectionNavigationBar

            helperBar

            ScrollView {
                VStack(spacing: 0) {
                    ControlSection(sectionID: selectedSection, columns: parameterColumns)
                }
                .padding(12)
            }
        }
        .background(DesignSystem.Colors.background)
        .onAppear {
            normalizeSelection()
        }
    }

    private var sectionNavigationBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(availableSections, id: \.self) { sectionID in
                    Button(action: { selectedSection = sectionID }) {
                        Text(ParameterRegistry.displayName(forSection: sectionID))
                            .font(DesignSystem.Typography.label)
                            .foregroundColor(
                                selectedSection == sectionID ?
                                DesignSystem.Colors.textPrimary :
                                DesignSystem.Colors.textSecondary
                            )
                            .padding(.horizontal, 10)
                            .frame(height: 28)
                            .background(
                                selectedSection == sectionID ?
                                DesignSystem.Colors.surface :
                                DesignSystem.Colors.background
                            )
                            .border(
                                width: 1,
                                edges: [.top, .leading, .trailing, .bottom],
                                color: selectedSection == sectionID ?
                                DesignSystem.Colors.border :
                                DesignSystem.Colors.border.opacity(0.35)
                            )
                    }
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 0)
            }
            .padding(8)
        }
        .background(DesignSystem.Colors.surfaceRaised)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    private var helperBar: some View {
        HStack {
            Text("Drag knobs · Double-click reset")
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Spacer()

            Text(ParameterRegistry.displayName(forSection: selectedSection))
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(DesignSystem.Colors.surface)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    private func normalizeSelection() {
        if !availableSections.contains(selectedSection) {
            selectedSection = availableSections.first ?? "disc"
        }
    }
}

struct ControlSection: View {
    @EnvironmentObject var appState: AppState
    let sectionID: String
    let columns: [GridItem]

    private var sectionName: String {
        ParameterRegistry.displayName(forSection: sectionID)
    }

    private var parameters: [Constants.Parameter] {
        ParameterRegistry.parameters(inSection: sectionID)
    }

    private var accentColor: Color {
        switch sectionID {
        case "mix":
            return DesignSystem.Colors.track1
        case "perform":
            return DesignSystem.Colors.track2
        case "sends":
            return DesignSystem.Colors.track3
        case "wave", "adsr", "random", "waveModulator":
            return DesignSystem.Colors.track4
        default:
            return DesignSystem.Colors.textPrimary
        }
    }

    private var isBipolarSection: Bool {
        sectionID == "mix"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(sectionID: sectionID, sectionName: sectionName)

            if parameters.isEmpty {
                Text("No parameters available in this section yet")
                    .font(DesignSystem.Typography.small)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.top, 8)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(parameters, id: \.id) { param in
                        ParameterControl(
                            parameter: param,
                            value: appState.getParameterValue(param.id),
                            showSlider: false,
                            accentColor: accentColor,
                            isBipolar: isBipolarSection,
                            onChange: { newValue in
                                appState.setParameterValue(param.id, newValue)
                            }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ControlTabView()
        .environmentObject(AppState())
}
