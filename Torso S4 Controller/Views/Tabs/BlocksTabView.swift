//
//  BlocksTabView.swift
//  Torso S4 Controller
//
//  BLOCKS Tab - Component Library & Sandbox
//  Design, test, and verify all UI components in isolation before deploying to tabs

import SwiftUI

struct BlocksTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            blockHeader
            blocksList
        }
        .background(DesignSystem.Colors.background)
    }

    // MARK: - Header
    private var blockHeader: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            Text("BLOCKS")
                .font(DesignSystem.Typography.display)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Component Library - Design, test, verify in isolation")
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surfaceRaised)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }

    // MARK: - Component List
    private var blocksList: some View {
        ScrollView(.vertical) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // MARK: - Basic Components
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "BASIC")

                    // Buttons
                    BlockSection(title: "Buttons") {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            Button(action: {}) {
                                Text("PLAY")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 50, height: 24)
                            }
                            .background(DesignSystem.Colors.surface)
                            .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                            Button(action: {}) {
                                Text("STOP")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 50, height: 24)
                            }
                            .background(DesignSystem.Colors.surface)
                            .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                            Button(action: {}) {
                                Text("RECORD")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.statusRed)
                                    .frame(width: 60, height: 24)
                            }
                            .background(DesignSystem.Colors.surface)
                            .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.statusRed)

                            Spacer()
                        }
                    }

                    // Dividers
                    BlockSection(title: "Dividers") {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            Divider()
                            Divider().frame(height: 20)
                            HStack {
                                Divider()
                                Text("or")
                                    .font(DesignSystem.Typography.small)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                Divider()
                            }
                        }
                    }

                    // Text Styles
                    BlockSection(title: "Typography") {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                Text("Display (16px)")
                                    .font(DesignSystem.Typography.display)
                                Spacer()
                            }

                            HStack {
                                Text("Title (13px)")
                                    .font(DesignSystem.Typography.title)
                                Spacer()
                            }

                            HStack {
                                Text("Body (11px)")
                                    .font(DesignSystem.Typography.body)
                                Spacer()
                            }

                            HStack {
                                Text("Label (10px)")
                                    .font(DesignSystem.Typography.label)
                                Spacer()
                            }

                            HStack {
                                Text("Small (9px)")
                                    .font(DesignSystem.Typography.small)
                                Spacer()
                            }
                        }
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                }

                // MARK: - Control Components
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "CONTROLS")

                    // Sliders
                    BlockSection(title: "Slider") {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            HStack(spacing: DesignSystem.Spacing.sm) {
                                Text("RATE")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .frame(width: 40)

                                Slider(value: .constant(64), in: 0...127)

                                Text("64")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 35, alignment: .trailing)
                            }

                            HStack(spacing: DesignSystem.Spacing.sm) {
                                Text("DEPTH")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .frame(width: 50)

                                Slider(value: .constant(32), in: 0...127)

                                Text("32")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                    }

                    // Pickers
                    BlockSection(title: "Picker/Dropdown") {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            VStack(alignment: .leading) {
                                Text("WAVEFORM")
                                    .font(DesignSystem.Typography.small)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)

                                Picker("Wave", selection: .constant("sine")) {
                                    Text("Sine").tag("sine")
                                    Text("Square").tag("square")
                                    Text("Triangle").tag("triangle")
                                    Text("Saw").tag("saw")
                                }
                                .font(DesignSystem.Typography.body)
                            }

                            VStack(alignment: .leading) {
                                Text("DIRECTION")
                                    .font(DesignSystem.Typography.small)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)

                                Picker("Dir", selection: .constant("FWD")) {
                                    Text("FWD").tag("FWD")
                                    Text("REV").tag("REV")
                                    Text("P-P").tag("P-P")
                                    Text("RAND").tag("RAND")
                                }
                                .font(DesignSystem.Typography.body)
                            }

                            Spacer()
                        }
                    }

                    // Toggle/Switch
                    BlockSection(title: "Toggles") {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            Toggle("Enable LFO", isOn: .constant(true))
                                .font(DesignSystem.Typography.label)

                            Toggle("Sync to BPM", isOn: .constant(false))
                                .font(DesignSystem.Typography.label)

                            Spacer()
                        }
                    }
                }

                // MARK: - Color Palette
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "COLORS")

                    BlockSection(title: "Background & Surface") {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            ColorBlock(color: DesignSystem.Colors.background, label: "BG")
                            ColorBlock(color: DesignSystem.Colors.surface, label: "Surface")
                            ColorBlock(color: DesignSystem.Colors.surfaceRaised, label: "Raised")
                            ColorBlock(color: DesignSystem.Colors.border, label: "Border")
                            Spacer()
                        }
                    }

                    BlockSection(title: "Text Colors") {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            ColorBlock(color: DesignSystem.Colors.textPrimary, label: "Primary")
                            ColorBlock(color: DesignSystem.Colors.textSecondary, label: "Secondary")
                            Spacer()
                        }
                    }

                    BlockSection(title: "Track Colors") {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            ColorBlock(color: DesignSystem.Colors.track1, label: "T1")
                            ColorBlock(color: DesignSystem.Colors.track2, label: "T2")
                            ColorBlock(color: DesignSystem.Colors.track3, label: "T3")
                            ColorBlock(color: DesignSystem.Colors.track4, label: "T4")
                            Spacer()
                        }
                    }

                    BlockSection(title: "Status Colors") {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            ColorBlock(color: DesignSystem.Colors.statusGreen, label: "OK")
                            ColorBlock(color: DesignSystem.Colors.statusRed, label: "Alert")
                            Spacer()
                        }
                    }
                }

                // MARK: - Sequencer Components
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "SEQUENCER")

                    BlockSection(title: "Step Cell (16×16 Grid)") {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            HStack(spacing: 1) {
                                ForEach(0..<16, id: \.self) { step in
                                    Button(action: {}) {
                                        Rectangle()
                                            .fill(step % 4 == 0 ? DesignSystem.Colors.track1 : DesignSystem.Colors.surfaceRaised)
                                            .overlay(Rectangle().strokeBorder(DesignSystem.Colors.border, lineWidth: 0.5))
                                    }
                                    .frame(width: 28, height: 28)
                                }
                            }
                            Text("16 steps × 4 tracks shown")
                                .font(DesignSystem.Typography.small)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }

                    BlockSection(title: "Sequencer Controls") {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                Button(action: {}) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 11, weight: .semibold))
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                .background(DesignSystem.Colors.surface)
                                .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                                Button(action: {}) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 11, weight: .semibold))
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                .background(DesignSystem.Colors.surface)
                                .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                                Divider().frame(height: 20)

                                Text("RATE").font(DesignSystem.Typography.label).foregroundColor(DesignSystem.Colors.textSecondary).frame(width: 40)
                                Slider(value: .constant(64), in: 0...127).frame(width: 80)
                                Text("64").font(DesignSystem.Typography.label).frame(width: 30)

                                Spacer()
                            }
                        }
                    }
                }

                // MARK: - LFO Components
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "LFOs")

                    BlockSection(title: "LFO Card") {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                    HStack {
                                        Circle()
                                            .fill(DesignSystem.Colors.track1)
                                            .frame(width: 12, height: 12)
                                        Text("LFO 1")
                                            .font(DesignSystem.Typography.label)
                                            .foregroundColor(DesignSystem.Colors.textPrimary)
                                    }

                                    VStack(spacing: DesignSystem.Spacing.xs) {
                                        HStack {
                                            Text("Wave").font(DesignSystem.Typography.small).foregroundColor(DesignSystem.Colors.textSecondary)
                                            Picker("", selection: .constant("sine")) {
                                                Text("Sine").tag("sine")
                                                Text("Square").tag("square")
                                            }
                                            .font(DesignSystem.Typography.body)
                                            .frame(width: 90)
                                        }

                                        HStack {
                                            Text("Rate").font(DesignSystem.Typography.small).foregroundColor(DesignSystem.Colors.textSecondary).frame(width: 35)
                                            Slider(value: .constant(60), in: 0...127)
                                            Text("60").font(DesignSystem.Typography.small).frame(width: 25)
                                        }

                                        HStack {
                                            Text("Depth").font(DesignSystem.Typography.small).foregroundColor(DesignSystem.Colors.textSecondary).frame(width: 35)
                                            Slider(value: .constant(64), in: 0...127)
                                            Text("64").font(DesignSystem.Typography.small).frame(width: 25)
                                        }
                                    }
                                }
                                Spacer()
                                Toggle("", isOn: .constant(true))
                            }
                            .padding(DesignSystem.Spacing.sm)
                            .background(DesignSystem.Colors.surface)
                            .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
                        }
                    }
                }

                // MARK: - Knob Components
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "KNOBS")

                    BlockSection(title: "Control Knob (56×56)") {
                        HStack(spacing: DesignSystem.Spacing.lg) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ZStack {
                                    Circle()
                                        .fill(DesignSystem.Colors.surface)
                                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                                    VStack {
                                        Rectangle()
                                            .fill(DesignSystem.Colors.track1)
                                            .frame(width: 2, height: 12)
                                        Spacer()
                                    }
                                    .frame(width: 56, height: 56)
                                }
                                .frame(width: 56, height: 56)

                                Text("K1")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                            }

                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ZStack {
                                    Circle()
                                        .fill(DesignSystem.Colors.surface)
                                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                                    VStack {
                                        Rectangle()
                                            .fill(DesignSystem.Colors.track2)
                                            .frame(width: 2, height: 12)
                                        Spacer()
                                    }
                                    .frame(width: 56, height: 56)
                                }
                                .frame(width: 56, height: 56)

                                Text("K2")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                            }

                            Spacer()
                        }
                    }

                    BlockSection(title: "Macro Knob (80×80)") {
                        HStack(spacing: DesignSystem.Spacing.lg) {
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                ZStack {
                                    Circle()
                                        .fill(DesignSystem.Colors.surface)
                                        .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

                                    VStack {
                                        Rectangle()
                                            .fill(DesignSystem.Colors.track3)
                                            .frame(width: 3, height: 16)
                                        Spacer()
                                    }
                                    .frame(width: 80, height: 80)
                                }
                                .frame(width: 80, height: 80)

                                Text("M1")
                                    .font(DesignSystem.Typography.label)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                            }

                            Spacer()
                        }
                    }
                }

                // MARK: - Spacing Reference
                VStack(spacing: DesignSystem.Spacing.md) {
                    CategoryHeader(title: "SPACING")

                    BlockSection(title: "Increments (4px base)") {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            SpacingRow(label: "XS (4px)", value: DesignSystem.Spacing.xs)
                            SpacingRow(label: "SM (8px)", value: DesignSystem.Spacing.sm)
                            SpacingRow(label: "MD (12px)", value: DesignSystem.Spacing.md)
                            SpacingRow(label: "LG (16px)", value: DesignSystem.Spacing.lg)
                            SpacingRow(label: "XL (20px)", value: DesignSystem.Spacing.xl)
                            SpacingRow(label: "XXL (24px)", value: DesignSystem.Spacing.xxl)
                        }
                    }
                }

                Spacer().frame(height: DesignSystem.Spacing.xl)
            }
            .padding(DesignSystem.Spacing.md)
        }
    }
}

// MARK: - Supporting Components

struct CategoryHeader: View {
    let title: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.title)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Divider()
        }
        .padding(.bottom, DesignSystem.Spacing.sm)
    }
}

struct BlockSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.label)
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Spacer()
            }

            content
                .padding(DesignSystem.Spacing.sm)
                .background(DesignSystem.Colors.surfaceRaised)
                .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)
        }
    }
}

struct ColorBlock: View {
    let color: Color
    let label: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 60, height: 60)
                .border(width: 1, edges: [.top, .leading, .trailing, .bottom], color: DesignSystem.Colors.border)

            Text(label)
                .font(DesignSystem.Typography.small)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}

struct SpacingRow: View {
    let label: String
    let value: CGFloat

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Text(label)
                .font(DesignSystem.Typography.label)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 80)

            RoundedRectangle(cornerRadius: 2)
                .fill(DesignSystem.Colors.track1)
                .frame(width: value * 4, height: 16)

            Spacer()
        }
    }
}

#Preview {
    BlocksTabView()
        .environmentObject(AppState())
}
