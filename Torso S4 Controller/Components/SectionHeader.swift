//
//  SectionHeader.swift
//  Torso S4 Controller
//
//  Collapsible section header with expand/collapse chevron
//

import SwiftUI

struct SectionHeader: View {
    @EnvironmentObject var appState: AppState
    let sectionID: String
    let sectionName: String

    private var isExpanded: Bool {
        appState.expandedSections.contains(sectionID)
    }

    var body: some View {
        Button(action: {
            appState.toggleSection(sectionID)
        }) {
            HStack(spacing: 8) {
                // Chevron icon
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))

                // Section name
                Text(sectionName)
                    .font(DesignSystem.Typography.regularFont)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()
            }
            .frame(height: DesignSystem.Dimensions.sectionHeaderHeight)
            .padding(.horizontal, 12)
            .background(DesignSystem.Colors.surfaceRaised)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
        .animation(DesignSystem.Animations.standardCurve, value: isExpanded)
    }
}

#Preview {
    SectionHeader(sectionID: "disc", sectionName: "Disc")
        .environmentObject(AppState())
}
