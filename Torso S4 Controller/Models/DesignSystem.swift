//
//  DesignSystem.swift
//  Torso S4 Controller
//
//  Design system defining colors, typography, and dimensions
//

import SwiftUI

struct DesignSystem {
    // MARK: - Colors (Dark Theme)

    struct Colors {
        // Background
        static let background = Color(red: 15/255, green: 17/255, blue: 20/255)       // #0f1114
        static let surface = Color(red: 21/255, green: 24/255, blue: 29/255)          // #15181d
        static let surfaceRaised = Color(red: 27/255, green: 31/255, blue: 37/255)    // #1b1f25
        static let border = Color(red: 42/255, green: 47/255, blue: 54/255)           // #2a2f36

        // Text
        static let textPrimary = Color(red: 231/255, green: 231/255, blue: 231/255)   // #e7e7e7
        static let textSecondary = Color(red: 168/255, green: 173/255, blue: 181/255) // #a8adb5

        // Status
        static let statusGreen = Color(red: 34/255, green: 197/255, blue: 94/255)     // #22c55e
        static let statusRed = Color(red: 239/255, green: 68/255, blue: 68/255)       // #ef4444

        // Track Colors
        static let track1 = Color(red: 0/255, green: 217/255, blue: 255/255)          // Cyan
        static let track2 = Color(red: 255/255, green: 0/255, blue: 255/255)          // Magenta
        static let track3 = Color(red: 255/255, green: 255/255, blue: 0/255)          // Yellow
        static let track4 = Color(red: 68/255, green: 255/255, blue: 68/255)          // Lime

        // LFO Colors (16 distinct)
        static let lfoColors: [Color] = [
            Color(red: 0/255, green: 217/255, blue: 255/255),      // Cyan
            Color(red: 255/255, green: 0/255, blue: 255/255),      // Magenta
            Color(red: 255/255, green: 255/255, blue: 0/255),      // Yellow
            Color(red: 68/255, green: 255/255, blue: 68/255),      // Lime
            Color(red: 255/255, green: 140/255, blue: 0/255),      // Orange
            Color(red: 0/255, green: 255/255, blue: 170/255),      // Cyan variant
            Color(red: 255/255, green: 105/255, blue: 180/255),    // Rose
            Color(red: 147/255, green: 112/255, blue: 219/255),    // Purple
            Color(red: 255/255, green: 255/255, blue: 100/255),    // Light yellow
            Color(red: 0/255, green: 255/255, blue: 127/255),      // Spring green
            Color(red: 64/255, green: 224/255, blue: 208/255),     // Turquoise
            Color(red: 218/255, green: 112/255, blue: 214/255),    // Orchid
            Color(red: 224/255, green: 255/255, blue: 255/255),    // Light cyan
            Color(red: 255/255, green: 215/255, blue: 0/255),      // Gold
            Color(red: 100/255, green: 149/255, blue: 237/255),    // Cornflower
            Color(red: 250/255, green: 128/255, blue: 114/255),    // Salmon
        ]

        static func lfoColor(_ index: Int) -> Color {
            lfoColors[index % lfoColors.count]
        }
    }

    // MARK: - Typography

    struct Typography {
        // Font: Monospaced system font
        static let family = "Menlo" // or "Monaco" on macOS

        // Simplified to 4 standard sizes with clear semantic meaning
        static let display = Font.system(size: 16, weight: .bold, design: .monospaced)      // Display/Logo (16px)
        static let title = Font.system(size: 13, weight: .bold, design: .monospaced)        // Section Title (13px)
        static let body = Font.system(size: 11, weight: .semibold, design: .monospaced)     // Body/Control (11px)
        static let label = Font.system(size: 10, weight: .regular, design: .monospaced)     // Label/Meta (10px)
        static let small = Font.system(size: 9, weight: .regular, design: .monospaced)      // Helper text (9px)

        // Legacy aliases (deprecated, use new names above)
        @available(*, deprecated, message: "Use Typography.body instead")
        static let labelFont = Font.system(.caption, design: .monospaced).weight(.medium)

        @available(*, deprecated, message: "Use Typography.small instead")
        static let smallFont = Font.system(.caption2, design: .monospaced).weight(.semibold)

        @available(*, deprecated, message: "Use Typography.body instead")
        static let regularFont = Font.system(.body, design: .monospaced).weight(.semibold)

        @available(*, deprecated, message: "Use Typography.title instead")
        static let largeFont = Font.system(.headline, design: .monospaced).weight(.bold)
    }

    // MARK: - Spacing (4px increments for consistency)

    struct Spacing {
        static let xs: CGFloat = 4        // Extra small spacing (internal)
        static let sm: CGFloat = 8        // Small spacing (default between elements)
        static let md: CGFloat = 12       // Medium spacing (section separation)
        static let lg: CGFloat = 16       // Large spacing (major sections)
        static let xl: CGFloat = 20       // Extra large spacing
        static let xxl: CGFloat = 24      // 2x Large spacing
    }

    // MARK: - Dimensions

    struct Dimensions {
        // Layout
        static let headerHeight: CGFloat = 92
        static let tabHeight: CGFloat = 32
        static let contentPadding: CGFloat = Spacing.md           // 12px padding around content
        static let spacing: CGFloat = Spacing.sm                  // 8px default spacing

        // Components
        static let knobSize: CGFloat = 56
        static let macroKnobSize: CGFloat = 80
        static let sliderHeight: CGFloat = 4
        static let sectionHeaderHeight: CGFloat = 32
        static let sequencerCellSize: CGFloat = 40
        static let snapshotButtonSize = CGSize(width: 36, height: 24)
        static let transportButtonSize: CGFloat = 32
        static let xyPadSize: CGFloat = 300

        // Minimums
        static let minWindowWidth: CGFloat = 1280
        static let minWindowHeight: CGFloat = 800
    }

    // MARK: - Animations

    struct Animations {
        static let standardDuration: CGFloat = 0.15
        static let standardCurve = Animation.easeInOut(duration: standardDuration)
    }
}
