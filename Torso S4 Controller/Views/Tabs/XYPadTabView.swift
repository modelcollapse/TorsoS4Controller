//
//  XYPadTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct XYPadTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("X Axis")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Text("Level")
                        .font(DesignSystem.Typography.smallFont)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Y Axis")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    Text("Filter")
                        .font(DesignSystem.Typography.smallFont)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }

                Spacer()

                Button(action: { appState.resetXYPad() }) {
                    Text("Reset")
                        .font(DesignSystem.Typography.smallFont)
                }
                .frame(height: 28)
                .padding(.horizontal, 12)
                .background(DesignSystem.Colors.surfaceRaised)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .cornerRadius(3)
            }
            .padding(16)
            .background(DesignSystem.Colors.surfaceRaised)

            Spacer()

            XYPadControl()

            Spacer()

            HStack(spacing: 16) {
                VStack(alignment: .center, spacing: 4) {
                    Text("X: \(Int(appState.xyPadPosition.x * 127))")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    Text("(0-127)")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                Spacer()

                VStack(alignment: .center, spacing: 4) {
                    Text("Y: \(Int(appState.xyPadPosition.y * 127))")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    Text("(0-127)")
                        .font(DesignSystem.Typography.labelFont)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
            .padding(16)
            .background(DesignSystem.Colors.surfaceRaised)
        }
        .padding(16)
        .background(DesignSystem.Colors.background)
    }
}

struct XYPadControl: View {
    @EnvironmentObject var appState: AppState
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(DesignSystem.Colors.surfaceRaised)
                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)

            Circle()
                .fill(DesignSystem.Colors.track1)
                .frame(width: 16, height: 16)
                .offset(
                    x: (appState.xyPadPosition.x - 0.5) * 300,
                    y: (appState.xyPadPosition.y - 0.5) * 300
                )

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
                .contentShape(RoundedRectangle(cornerRadius: 8))
                .gesture(DragGesture()
                    .onChanged { gesture in
                        let frame = CGSize(width: 340, height: 300)
                        let x = gesture.location.x / frame.width
                        let y = gesture.location.y / frame.height
                        appState.setXYPadPosition(CGPoint(x: x, y: y))
                    }
                )
        }
        .frame(height: 300)
        .frame(maxWidth: 300)
    }
}

#Preview {
    XYPadTabView()
        .environmentObject(AppState())
}
