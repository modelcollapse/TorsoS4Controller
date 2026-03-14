//
//  TabNavigation.swift
//  Torso S4 Controller
//
//  Tab selection bar with app navigation labels
//

import SwiftUI

struct TabNavigation: View {
    @EnvironmentObject var appState: AppState

    let tabs: [(TabSelection, String)] = [
        (.control, "Tracks"),
        (.sequencer, "Compose"),
        (.lfos, "Modulate"),
        (.macros, "Macros"),
        (.blocks, "Components"),
        (.song, "Song"),
        (.field, "Spatial"),
        (.xypad, "XY Pad"),
        (.knobs, "Knob Record"),
        (.settings, "Settings"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.0) { tab, label in
                TabButton(
                    label: label,
                    isSelected: appState.selectedTab == tab,
                    action: {
                        withAnimation(DesignSystem.Animations.standardCurve) {
                            appState.selectedTab = tab
                        }
                    }
                )
            }
            Spacer()
        }
        .background(DesignSystem.Colors.surfaceRaised)
    }
}

struct TabButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DesignSystem.Typography.regularFont)
                .foregroundColor(
                    isSelected ?
                    DesignSystem.Colors.textPrimary :
                    DesignSystem.Colors.textSecondary
                )
                .frame(height: DesignSystem.Dimensions.tabHeight)
                .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .background(
            isSelected ?
            DesignSystem.Colors.surface :
            DesignSystem.Colors.surfaceRaised
        )
        .border(width: 1, edges: [.bottom], color: isSelected ? DesignSystem.Colors.border : .clear)
    }
}

#Preview {
    TabNavigation()
        .environmentObject(AppState())
        .frame(height: DesignSystem.Dimensions.tabHeight)
}
