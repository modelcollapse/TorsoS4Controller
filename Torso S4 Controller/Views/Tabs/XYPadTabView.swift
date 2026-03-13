//
//  XYPadTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct XYPadTabView: View {
    var body: some View {
        VStack {
            Text("XY Pad Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    XYPadTabView()
}
