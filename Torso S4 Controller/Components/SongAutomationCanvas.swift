//
//  SongAutomationCanvas.swift
//  Torso S4 Controller
//

import SwiftUI

struct SongAutomationCanvas: View {
    @EnvironmentObject var appState: AppState
    let track: String
    @State private var hoveredPointIndex: Int? = nil
    @State private var selectedPointIndex: Int? = nil
    @State private var canvasSize: CGSize = .zero

    var trackColor: Color {
        switch track {
        case "T1": return DesignSystem.Colors.track1  // Cyan
        case "T2": return DesignSystem.Colors.track2  // Magenta
        case "T3": return DesignSystem.Colors.track3  // Yellow
        case "T4": return DesignSystem.Colors.track4  // Lime
        default: return DesignSystem.Colors.track1
        }
    }

    var points: [CGPoint] {
        appState.songCurves[track] ?? []
    }

    var body: some View {
        Canvas { context, size in
            canvasSize = size

            // Draw grid lines (0, 64, 127 MIDI values)
            drawGridLines(context: context, size: size)

            // Draw automation curve (Catmull-Rom spline)
            if !points.isEmpty {
                drawAutomationCurve(context: context, size: size, points: points)
            }

            // Draw breakpoint dots
            drawBreakpoints(context: context, size: size, points: points)

            // Draw playhead if playing
            if appState.isSequencerPlaying {
                drawPlayhead(context: context, size: size)
            }
        }
        .background(DesignSystem.Colors.surface)
        .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: DesignSystem.Colors.border)
        .onTapGesture { location in
            addBreakpoint(at: location)
        }
        .onContinuousHover { phase in
            switch phase {
            case .active(let location):
                hoveredPointIndex = findNearestPoint(at: location)
            case .ended:
                hoveredPointIndex = nil
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if selectedPointIndex == nil {
                        selectedPointIndex = findNearestPoint(at: value.startLocation)
                    }
                    if let idx = selectedPointIndex {
                        moveBreakpoint(index: idx, to: value.location)
                    }
                }
                .onEnded { _ in
                    selectedPointIndex = nil
                }
        )
    }

    private func drawGridLines(context: GraphicsContext, size: CGSize) {
        let gridColor = DesignSystem.Colors.textSecondary.opacity(0.15)
        let height = size.height

        // Grid lines at MIDI values 0, 64, 127
        let positions = [0.0, 64.0 / 127.0, 1.0]
        for position in positions {
            let y = height * (1 - position)
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))

            context.stroke(
                path,
                with: .color(gridColor),
                lineWidth: 1
            )
        }
    }

    private func drawAutomationCurve(context: GraphicsContext, size: CGSize, points: [CGPoint]) {
        guard points.count > 1 else { return }

        var path = Path()

        // Start at first point
        let firstPoint = convertDataToUI(points[0], size: size)
        path.move(to: firstPoint)

        // Draw line segments between points (simplified, not Catmull-Rom for now)
        for i in 1..<points.count {
            let point = convertDataToUI(points[i], size: size)
            path.addLine(to: point)
        }

        context.stroke(
            path,
            with: .color(trackColor),
            lineWidth: 2
        )
    }

    private func drawBreakpoints(context: GraphicsContext, size: CGSize, points: [CGPoint]) {
        for (index, point) in points.enumerated() {
            let uiPoint = convertDataToUI(point, size: size)
            let radius = (index == selectedPointIndex) ? 6.0 : 4.0
            let dotColor = (index == hoveredPointIndex) ? trackColor.opacity(0.8) : trackColor

            context.fill(
                Path(ellipseIn: CGRect(x: uiPoint.x - radius, y: uiPoint.y - radius,
                                       width: radius * 2, height: radius * 2)),
                with: .color(dotColor)
            )
        }
    }

    private func drawPlayhead(context: GraphicsContext, size: CGSize) {
        let playheadX = size.width * appState.songPlaybackPosition
        var path = Path()
        path.move(to: CGPoint(x: playheadX, y: 0))
        path.addLine(to: CGPoint(x: playheadX, y: size.height))

        context.stroke(
            path,
            with: .color(trackColor.opacity(0.6)),
            lineWidth: 2
        )
    }

    private func convertDataToUI(_ point: CGPoint, size: CGSize) -> CGPoint {
        let x = point.x * size.width
        let y = size.height * (1 - point.y)
        return CGPoint(x: x, y: y)
    }

    private func convertUIToData(_ point: CGPoint, size: CGSize) -> CGPoint {
        let x = max(0, min(1, point.x / size.width))
        let y = max(0, min(1, 1 - (point.y / size.height)))
        return CGPoint(x: x, y: y)
    }

    private func addBreakpoint(at location: CGPoint) {
        guard canvasSize.width > 0 else { return }
        let dataPoint = convertUIToData(location, size: canvasSize)
        appState.addSongCurvePoint(track, dataPoint)
    }

    private func moveBreakpoint(index: Int, to location: CGPoint) {
        guard index >= 0, index < points.count, canvasSize.width > 0 else { return }

        let newPoint = convertUIToData(location, size: canvasSize)

        var updatedPoints = points
        updatedPoints[index] = newPoint
        appState.songCurves[track] = updatedPoints
    }

    private func findNearestPoint(at location: CGPoint) -> Int? {
        guard canvasSize.width > 0 else { return nil }
        let threshold: CGFloat = 12

        for (index, point) in points.enumerated() {
            let uiPoint = convertDataToUI(point, size: canvasSize)
            let distance = hypot(location.x - uiPoint.x, location.y - uiPoint.y)

            if distance < threshold {
                return index
            }
        }

        return nil
    }
}

#Preview {
    SongAutomationCanvas(track: "T1")
        .environmentObject(AppState())
        .frame(height: 120)
}
