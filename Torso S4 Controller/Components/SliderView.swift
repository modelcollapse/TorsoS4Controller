//
//  SliderView.swift
//  Torso S4 Controller
//
//  Parameter value slider (4px height, full width)
//

import SwiftUI

struct SliderView: View {
    let value: Int
    let onChange: (Int) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.surfaceRaised)

                // Value indicator
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.textPrimary)
                    .frame(width: (CGFloat(value) / 127.0) * geometry.size.width)
            }
            .frame(height: DesignSystem.Dimensions.sliderHeight)
            .contentShape(Rectangle())
            .gesture(DragGesture()
                .onChanged { gesture in
                    let ratio = gesture.location.x / geometry.size.width
                    let newValue = Int(ratio * 127.0)
                    onChange(max(0, min(127, newValue)))
                }
            )
        }
        .frame(height: DesignSystem.Dimensions.sliderHeight)
    }
}

#Preview {
    SliderView(value: 64, onChange: { _ in })
        .frame(height: 4)
        .padding()
}
