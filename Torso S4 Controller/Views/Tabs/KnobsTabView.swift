//
//  KnobsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct KnobsTabView: View {
    var body: some View {
        VStack {
            Text("Knobs Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    KnobsTabView()
}
