//
//  SongTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SongTabView: View {
    var body: some View {
        VStack {
            Text("Song Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    SongTabView()
}
