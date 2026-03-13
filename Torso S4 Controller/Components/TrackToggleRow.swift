//
//  TrackToggleRow.swift
//  Torso S4 Controller
//
//  Track selection buttons: ALL, T1, T2, T3, T4
//

import SwiftUI

struct TrackToggleRow: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            // ALL button - toggle all tracks
            Button(action: {
                if appState.activeTracks.count == 4 {
                    appState.activeTracks.removeAll()
                } else {
                    appState.activeTracks = Set(1...4)
                }
            }) {
                Text("ALL")
                    .font(DesignSystem.Typography.smallFont)
                    .foregroundColor(
                        appState.activeTracks.count == 4 ?
                        DesignSystem.Colors.textPrimary :
                        DesignSystem.Colors.textSecondary
                    )
            }
            .buttonStyle(.plain)
            .frame(width: 44, height: 28)
            .background(
                appState.activeTracks.count == 4 ?
                DesignSystem.Colors.surface :
                DesignSystem.Colors.surfaceRaised
            )
            .cornerRadius(3)
            .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: DesignSystem.Colors.border)

            Divider()
                .frame(height: 24)

            // Individual track buttons
            ForEach(1...4, id: \.self) { track in
                TrackButton(track: track)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

struct TrackButton: View {
    @EnvironmentObject var appState: AppState
    let track: Int

    private var isActive: Bool {
        appState.activeTracks.contains(track)
    }

    private var trackColor: Color {
        switch track {
        case 1: return DesignSystem.Colors.track1
        case 2: return DesignSystem.Colors.track2
        case 3: return DesignSystem.Colors.track3
        case 4: return DesignSystem.Colors.track4
        default: return DesignSystem.Colors.textSecondary
        }
    }

    var body: some View {
        Button(action: {
            appState.toggleTrack(track)
        }) {
            Text("T\(track)")
                .font(DesignSystem.Typography.smallFont)
                .foregroundColor(isActive ? trackColor : DesignSystem.Colors.textSecondary)
        }
        .buttonStyle(.plain)
        .frame(width: 44, height: 28)
        .background(
            isActive ?
            DesignSystem.Colors.surface :
            DesignSystem.Colors.surfaceRaised
        )
        .cornerRadius(3)
        .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: DesignSystem.Colors.border)
    }
}

#Preview {
    TrackToggleRow()
        .environmentObject(AppState())
}
