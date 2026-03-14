//
//  ParameterControl.swift
//  Torso S4 Controller
//
//  Shared parameter control: knob + optional slider + labels
//

import SwiftUI

struct ParameterControl: View {
    let parameter: Constants.Parameter
    let value: Int
    let showSlider: Bool
    let accentColor: Color
    let isBipolar: Bool
    let onChange: (Int) -> Void

    init(
        parameter: Constants.Parameter,
        value: Int,
        showSlider: Bool = true,
        accentColor: Color = DesignSystem.Colors.textPrimary,
        isBipolar: Bool = false,
        onChange: @escaping (Int) -> Void
    ) {
        self.parameter = parameter
        self.value = value
        self.showSlider = showSlider
        self.accentColor = accentColor
        self.isBipolar = isBipolar
        self.onChange = onChange
    }

    var body: some View {
        VStack(spacing: 6) {
            KnobView(
                label: nil,
                value: value,
                defaultValue: 64,
                accentColor: accentColor,
                isBipolar: isBipolar,
                onChange: onChange
            )

            if showSlider {
                SliderView(value: value, onChange: onChange)
            }

            VStack(spacing: 2) {
                Text(parameter.name.uppercased())
                    .font(DesignSystem.Typography.label)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)

                Text("CC \(parameter.cc)")
                    .font(DesignSystem.Typography.small)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .monospacedDigit()
            }
        }
        .frame(width: DesignSystem.Dimensions.knobSize + 12)
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

    VStack(spacing: 20) {
        ParameterControl(parameter: param, value: 64, onChange: { _ in })
        ParameterControl(parameter: param, value: 96, showSlider: false, accentColor: DesignSystem.Colors.track1, onChange: { _ in })
        ParameterControl(parameter: param, value: 64, accentColor: DesignSystem.Colors.track2, isBipolar: true, onChange: { _ in })
    }
    .padding()
    .background(DesignSystem.Colors.background)
}
