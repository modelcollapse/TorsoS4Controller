//
//  ParameterControl.swift
//  Torso S4 Controller
//
//  Complete parameter control: Knob + Slider + Labels
//

import SwiftUI

struct ParameterControl: View {
    let parameter: Constants.Parameter
    let value: Int
    let onChange: (Int) -> Void

    var body: some View {
        VStack(spacing: 4) {
            // Knob
            KnobView(value: value, onChange: onChange)

            // Slider
            SliderView(value: value, onChange: onChange)

            // Parameter name
            Text(parameter.name)
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(1)

            // CC number
            Text("CC \(parameter.cc)")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(width: DesignSystem.Dimensions.knobSize + 8)
    }
}

#Preview {
    let param = Constants.Parameter(
        id: "test_param",
        name: "Speed",
        section: "disc",
        cc: 46,
        channel: .track1
    )
    return ParameterControl(parameter: param, value: 64, onChange: { _ in })
        .padding()
}
