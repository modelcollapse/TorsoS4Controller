//
//  KnobView.swift
//  Torso S4 Controller
//
//  Shared knob system for numeric controls across tabs
//

import SwiftUI

struct KnobView: View {
    let label: String?
    let value: Int
    let range: ClosedRange<Int>
    let defaultValue: Int
    let accentColor: Color
    let isBipolar: Bool
    let size: CGFloat
    let onChange: (Int) -> Void

    @State private var isDragging = false
    @State private var lastY: CGFloat = 0

    init(
        label: String? = nil,
        value: Int,
        range: ClosedRange<Int> = 0...127,
        defaultValue: Int = 64,
        accentColor: Color = DesignSystem.Colors.textPrimary,
        isBipolar: Bool = false,
        size: CGFloat = DesignSystem.Dimensions.knobSize,
        onChange: @escaping (Int) -> Void
    ) {
        self.label = label
        self.value = value
        self.range = range
        self.defaultValue = defaultValue
        self.accentColor = accentColor
        self.isBipolar = isBipolar
        self.size = size
        self.onChange = onChange
    }

    private var normalizedValue: Double {
        let span = Double(range.upperBound - range.lowerBound)
        guard span > 0 else { return 0 }
        return Double(value - range.lowerBound) / span
    }

    private var angle: Double {
        normalizedValue * 270.0 - 135.0
    }

    private var clampedDefaultValue: Int {
        min(max(defaultValue, range.lowerBound), range.upperBound)
    }

    private var trackLineWidth: CGFloat {
        size <= 44 ? 1.5 : 2
    }

    private var arcRadius: CGFloat {
        max(10, (size / 2) - 8)
    }

    var body: some View {
        VStack(spacing: 6) {
            if let label {
                Text(label)
                    .font(DesignSystem.Typography.label)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
            }

            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.surfaceRaised)
                    .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)

                Canvas { context, canvasSize in
                    let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)

                    var fullArc = Path()
                    fullArc.addArc(
                        center: center,
                        radius: arcRadius,
                        startAngle: .degrees(-135),
                        endAngle: .degrees(135),
                        clockwise: false
                    )
                    context.stroke(
                        fullArc,
                        with: .color(DesignSystem.Colors.border.opacity(0.3)),
                        lineWidth: trackLineWidth
                    )

                    if isBipolar {
                        let midpointAngle = 0.0
                        let currentAngle = angle
                        var bipolarArc = Path()
                        bipolarArc.addArc(
                            center: center,
                            radius: arcRadius,
                            startAngle: .degrees(min(midpointAngle, currentAngle)),
                            endAngle: .degrees(max(midpointAngle, currentAngle)),
                            clockwise: false
                        )
                        context.stroke(
                            bipolarArc,
                            with: .color(accentColor),
                            lineWidth: trackLineWidth
                        )
                    } else {
                        var valueArc = Path()
                        valueArc.addArc(
                            center: center,
                            radius: arcRadius,
                            startAngle: .degrees(-135),
                            endAngle: .degrees(angle),
                            clockwise: false
                        )
                        context.stroke(
                            valueArc,
                            with: .color(accentColor),
                            lineWidth: trackLineWidth
                        )
                    }
                }
                .frame(width: size, height: size)

                Text("\(value)")
                    .font(size <= 44 ? DesignSystem.Typography.body : DesignSystem.Typography.title)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .monospacedDigit()
            }
            .frame(width: size, height: size)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if !isDragging {
                            isDragging = true
                            lastY = gesture.location.y
                        }

                        let delta = lastY - gesture.location.y
                        let sensitivity: CGFloat = size <= 44 ? 0.8 : 0.5
                        let newValue = Int(Double(value) + delta * sensitivity)
                        onChange(min(max(newValue, range.lowerBound), range.upperBound))
                        lastY = gesture.location.y
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
            .onTapGesture(count: 2) {
                onChange(clampedDefaultValue)
            }
        }
        .frame(minWidth: size)
    }
}

struct CompactKnobView: View {
    let label: String
    let value: Int
    let onChange: (Int) -> Void

    var body: some View {
        KnobView(
            label: label,
            value: value,
            size: 44,
            onChange: onChange
        )
    }
}

struct MacroKnobView: View {
    let label: String
    let value: Int
    let accentColor: Color
    let onChange: (Int) -> Void

    var body: some View {
        KnobView(
            label: label,
            value: value,
            defaultValue: 64,
            accentColor: accentColor,
            size: 80,
            onChange: onChange
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        KnobView(label: "RATE", value: 64, onChange: { _ in })
        HStack(spacing: 20) {
            CompactKnobView(label: "DEPTH", value: 48, onChange: { _ in })
            KnobView(label: "PAN", value: 64, isBipolar: true, onChange: { _ in })
            MacroKnobView(label: "MACRO 1", value: 92, accentColor: DesignSystem.Colors.track1, onChange: { _ in })
        }
    }
    .padding()
    .background(DesignSystem.Colors.background)
}
