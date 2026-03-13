//
//  SettingsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        VStack {
            Text("Settings Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    SettingsTabView()
}
