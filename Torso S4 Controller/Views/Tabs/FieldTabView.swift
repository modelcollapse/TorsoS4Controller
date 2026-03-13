//
//  FieldTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct FieldTabView: View {
    var body: some View {
        VStack {
            Text("Field Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    FieldTabView()
}
