//
//  FieldTabView.swift
//  Torso S4 Controller
//

import SwiftUI

struct FieldTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                ForEach(1...4, id: \.self) { node in
                    HStack(spacing: 12) {
                        Text("Node \(node):")
                            .font(DesignSystem.Typography.smallFont)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        Picker("", selection: .init(
                            get: { appState.fieldAssignments[node] ?? "mix_t1_pan" },
                            set: { appState.assignFieldNode(node, paramID: $0) }
                        )) {
                            ForEach(Constants.parameters, id: \.id) { param in
                                Text(param.name).tag(param.id)
                            }
                        }
                        .font(DesignSystem.Typography.smallFont)
                        Spacer()
                    }
                }
            }
            .padding(12)
            .background(DesignSystem.Colors.surfaceRaised)

            Spacer()

            FieldGrid()

            Spacer()
        }
        .padding(16)
        .background(DesignSystem.Colors.background)
    }
}

struct FieldGrid: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(DesignSystem.Colors.surfaceRaised)
                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)

            ForEach(1...4, id: \.self) { node in
                if let position = appState.fieldNodes[node] {
                    Circle()
                        .fill(DesignSystem.Colors.track2)
                        .frame(width: 20, height: 20)
                        .offset(
                            x: (position.x - 0.5) * 350,
                            y: (position.y - 0.5) * 300
                        )
                        .gesture(DragGesture()
                            .onChanged { gesture in
                                let frame = CGSize(width: 400, height: 300)
                                let x = gesture.location.x / frame.width
                                let y = gesture.location.y / frame.height
                                appState.setFieldNodePosition(node, CGPoint(x: x, y: y))
                            }
                        )
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    FieldTabView()
        .environmentObject(AppState())
}
