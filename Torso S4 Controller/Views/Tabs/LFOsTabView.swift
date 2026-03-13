//
//  LFOsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct LFOsTabView: View {
    var body: some View {
        VStack {
            Text("LFOs Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    LFOsTabView()
}
