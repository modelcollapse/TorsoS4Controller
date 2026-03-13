//
//  MacrosTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct MacrosTabView: View {
    var body: some View {
        VStack {
            Text("Macros Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    MacrosTabView()
}
