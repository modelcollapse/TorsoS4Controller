//
//  KnobView.swift
//  Torso S4 Controller
//
//  56×56px knob with SVG arc design and drag interaction
//

import SwiftUI

struct KnobView: View {
    let value: Int
    let onChange: (Int) -> Void

    @State private var isDragging = false
    @State private var lastY: CGFloat = 0

    // Convert value (0-127) to angle (0-270 degrees, covering 3/4 circle)
    private var angle: Double {
        Double(value) / 127.0 * 270.0 - 135.0
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(DesignSystem.Colors.surfaceRaised)
                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)

            // Arc track (0-127 range, faint)
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius: CGFloat = 20

                // Draw background arc (full range)
                var arcPath = Path()
                arcPath.addArc(center: center,
                              radius: radius,
                              startAngle: .degrees(-135),
                              endAngle: .degrees(135),
                              clockwise: false)
                context.stroke(arcPath,
                             with: .color(DesignSystem.Colors.border.opacity(0.3)),
                             lineWidth: 2)

                // Draw value arc (colored)
                var valuePath = Path()
                valuePath.addArc(center: center,
                               radius: radius,
                               startAngle: .degrees(-135),
                               endAngle: .degrees(angle),
                               clockwise: false)
                context.stroke(valuePath,
                             with: .color(DesignSystem.Colors.textPrimary),
                             lineWidth: 2)
            }
            .frame(width: DesignSystem.Dimensions.knobSize,
                   height: DesignSystem.Dimensions.knobSize)

            // Center value display
            VStack(spacing: 0) {
                Text("\(value)")
                    .font(DesignSystem.Typography.largeFont)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
        }
        .frame(width: DesignSystem.Dimensions.knobSize,
               height: DesignSystem.Dimensions.knobSize)
        .gesture(DragGesture()
            .onChanged { gesture in
                if !isDragging {
                    isDragging = true
                    lastY = gesture.location.y
                }

                let delta = lastY - gesture.location.y
                let sensitivity: CGFloat = 0.5
                let newValue = Int(Double(value) + delta * sensitivity)
                onChange(max(0, min(127, newValue)))
                lastY = gesture.location.y
            }
            .onEnded { _ in
                isDragging = false
            }
        )
        .onTapGesture(count: 2) {
            onChange(64) // Reset to center value
        }
    }
}

#Preview {
    KnobView(value: 64, onChange: { _ in })
}
