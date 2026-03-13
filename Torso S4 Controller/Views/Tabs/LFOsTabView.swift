//
//  LFOsTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct LFOsTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { appState.addLFO() }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Add LFO")
                        .font(DesignSystem.Typography.smallFont)
                }
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(12)
                Spacer()
            }
            .background(DesignSystem.Colors.surfaceRaised)
            .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 12)],
                         spacing: 12) {
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

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(DesignSystem.Colors.lfoColor(index - 1))
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

            Divider()

            VStack(spacing: 6) {
                HStack {
                    Text("Wave:")
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

                VStack(spacing: 3) {
                    HStack {
                        Text("Rate").font(DesignSystem.Typography.labelFont)
                        Spacer()
                        Text("\(lfo.rate)").font(DesignSystem.Typography.labelFont)
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                    Slider(value: .init(
                        get: { Double(lfo.rate) },
                        set: { appState.updateLFO(index, rate: Int($0)) }
                    ), in: 0...127)
                }

                VStack(spacing: 3) {
                    HStack {
                        Text("Depth").font(DesignSystem.Typography.labelFont)
                        Spacer()
                        Text("\(lfo.depth)").font(DesignSystem.Typography.labelFont)
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                    Slider(value: .init(
                        get: { Double(lfo.depth) },
                        set: { appState.updateLFO(index, depth: Int($0)) }
                    ), in: 0...127)
                }

                VStack(spacing: 3) {
                    HStack {
                        Text("Phase").font(DesignSystem.Typography.labelFont)
                        Spacer()
                        Text("\(lfo.phase)").font(DesignSystem.Typography.labelFont)
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                    Slider(value: .init(
                        get: { Double(lfo.phase) },
                        set: { appState.updateLFO(index, phase: Int($0)) }
                    ), in: 0...127)
                }

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
}

#Preview {
    LFOsTabView()
        .environmentObject(AppState())
}
