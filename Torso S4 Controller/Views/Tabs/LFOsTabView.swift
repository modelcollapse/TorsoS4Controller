//
//  LFOsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct LFOsTabView: View {
    @EnvironmentObject var appState: AppState

    private let columns = [
        GridItem(.adaptive(minimum: 320), spacing: 12, alignment: .top)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { appState.addLFO() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Add LFO")
                            .font(DesignSystem.Typography.smallFont)
                    }
                }
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(12)

                Spacer()
            }
            .background(DesignSystem.Colors.surfaceRaised)
            .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(1...16, id: \.self) { index in
                        if let lfo = appState.lfos[index] {
                            LFOCard(index: index, lfo: lfo)
                        }
                    }
                }
                .padding(12)
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

struct LFOCard: View {
    @EnvironmentObject var appState: AppState
    let index: Int
    let lfo: LFOModel

    private var accent: Color {
        DesignSystem.Colors.lfoColor(index - 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerRow

            Divider()

            waveformRow

            knobRow

            toggleRow

            Divider()

            LFOWaveformPreview(waveform: lfo.waveform, depth: lfo.depth, rate: lfo.rate, accentColor: accent)
                .frame(height: 72)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(3)

            Divider()

            Button(action: { appState.removeLFO(index) }) {
                Text("Remove")
                    .font(DesignSystem.Typography.labelFont)
                    .foregroundColor(DesignSystem.Colors.statusRed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
            }
            .buttonStyle(.plain)
            .background(DesignSystem.Colors.surfaceRaised)
            .cornerRadius(3)
        }
        .padding(12)
        .background(DesignSystem.Colors.surfaceRaised)
        .cornerRadius(6)
    }

    private var headerRow: some View {
        HStack {
            Circle()
                .fill(accent)
                .frame(width: 12, height: 12)

            Text("LFO \(index)")
                .font(DesignSystem.Typography.regularFont)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Spacer()

            Toggle("", isOn: .init(
                get: { lfo.enabled },
                set: { appState.updateLFO(index, enabled: $0) }
            ))
            .labelsHidden()
        }
    }

    private var waveformRow: some View {
        HStack(spacing: 8) {
            Text("Wave")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Picker("", selection: .init(
                get: { lfo.waveform },
                set: { appState.updateLFO(index, waveform: $0) }
            )) {
                Text("Sine").tag("sine")
                Text("Square").tag("square")
                Text("Triangle").tag("triangle")
                Text("Saw").tag("saw")
            }
            .font(DesignSystem.Typography.labelFont)

            Spacer()
        }
    }

    private var knobRow: some View {
        HStack(alignment: .top, spacing: 14) {
            CompactKnobView(
                label: "RATE",
                value: lfo.rate,
                onChange: { appState.updateLFO(index, rate: $0) }
            )

            CompactKnobView(
                label: "DEPTH",
                value: lfo.depth,
                onChange: { appState.updateLFO(index, depth: $0) }
            )

            CompactKnobView(
                label: "PHASE",
                value: lfo.phase,
                onChange: { appState.updateLFO(index, phase: $0) }
            )

            Spacer(minLength: 0)
        }
    }

    private var toggleRow: some View {
        HStack {
            Text("BPM Sync")
                .font(DesignSystem.Typography.labelFont)
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Spacer()

            Toggle("", isOn: .init(
                get: { lfo.bpmSync },
                set: { appState.updateLFO(index, bpmSync: $0) }
            ))
            .labelsHidden()
        }
    }
}

struct LFOWaveformPreview: View {
    let waveform: String
    let depth: Int
    let rate: Int
    let accentColor: Color

    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            let centerY = height / 2

            let gridColor = DesignSystem.Colors.textSecondary
            context.stroke(
                Path(CGRect(x: 0, y: centerY, width: width, height: 1)),
                with: .color(gridColor.opacity(0.2)),
                lineWidth: 1
            )

            var path = Path()
            let steps = max(1, Int(width))
            let depthScale = CGFloat(depth) / 127.0

            for step in 0...steps {
                let phase = CGFloat(step) / CGFloat(steps)
                let value = sampleWaveform(waveform, phase: phase, depth: depthScale)
                let x = (CGFloat(step) / CGFloat(steps)) * width
                let y = centerY - (value * height * 0.4)

                if step == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }

            context.stroke(
                path,
                with: .color(accentColor),
                lineWidth: 2
            )
        }
    }

    private func sampleWaveform(_ type: String, phase: CGFloat, depth: CGFloat) -> CGFloat {
        let p = phase.truncatingRemainder(dividingBy: 1.0)
        let value: CGFloat

        switch type.lowercased() {
        case "sine":
            value = sin(p * .pi * 2) * depth
        case "square":
            value = (p < 0.5 ? 1.0 : -1.0) * depth
        case "triangle":
            value = (p < 0.5 ? (p * 4 - 1) : (3 - p * 4)) * depth
        case "saw":
            value = (p * 2 - 1) * depth
        default:
            value = sin(p * .pi * 2) * depth
        }

        return value
    }
}

#Preview {
    LFOsTabView()
        .environmentObject(AppState())
}
