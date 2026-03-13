//
//  SequencerTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct SequencerTabView: View {
    var body: some View {
        VStack {
            Text("Sequencer Tab")
                .font(DesignSystem.Typography.largeFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
        .padding()
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    SequencerTabView()
}
