//
//  MainView.swift
//  Torso S4 Controller
//
//  Root layout container for the app
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Header
            AppHeader()
                .frame(height: DesignSystem.Dimensions.headerHeight)
                .background(DesignSystem.Colors.surface)
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            // Tab Navigation
            TabNavigation()
                .frame(height: DesignSystem.Dimensions.tabHeight)
                .background(DesignSystem.Colors.surfaceRaised)
                .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)

            // Workspace Content
            Group {
                switch appState.selectedTab {
                case .control:
                    ControlTabView()
                case .sequencer:
                    SequencerTabView()
                case .lfos:
                    LFOsTabView()
                case .knobs:
                    KnobsTabView()
                case .macros:
                    MacrosTabView()
                case .xypad:
                    XYPadTabView()
                case .song:
                    SongTabView()
                case .field:
                    FieldTabView()
                case .settings:
                    SettingsTabView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignSystem.Colors.background)
        }
        .background(DesignSystem.Colors.background)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainView()
        .environmentObject(AppState())
}

// MARK: - Border Extension Helper

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            switch edge {
            case .top:
                path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom:
                path.addRect(CGRect(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading:
                path.addRect(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing:
                path.addRect(CGRect(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }
        return path
    }
}
