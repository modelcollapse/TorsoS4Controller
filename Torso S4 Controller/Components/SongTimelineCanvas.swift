//
//  SongTimelineCanvas.swift
//  Torso S4 Controller
//
//  Beat marker timeline for Song automation

import SwiftUI

struct SongTimelineCanvas: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            
            // Background
            context.fill(
                Path(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 0),
                with: .color(DesignSystem.Colors.surface)
            )
            
            // Calculate bar width
            let numBars = appState.songLength
            let barWidth = width / CGFloat(numBars)
            
            // Draw bar separators and numbers
            for bar in 0...numBars {
                let x = CGFloat(bar) * barWidth
                
                // Vertical line at each bar
                var linePath = Path()
                linePath.move(to: CGPoint(x: x, y: 0))
                linePath.addLine(to: CGPoint(x: x, y: height))
                context.stroke(
                    linePath,
                    with: .color(bar % 4 == 0 ? 
                        DesignSystem.Colors.textSecondary : 
                        DesignSystem.Colors.border.opacity(0.3)),
                    lineWidth: bar % 4 == 0 ? 1.5 : 0.5
                )
                
                // Bar numbers (every 4 bars)
                if bar % 4 == 0 && bar < numBars {
                    let barText = "\(bar)"
                    let textPath = Path(CGRect(x: x + 2, y: height - 14, width: 30, height: 12))
                    context.fill(textPath, with: .color(.clear))
                }
            }
            
            // Draw beat ticks (4 beats per bar)
            for beat in 0...(numBars * 4) {
                let beatFraction = CGFloat(beat) / CGFloat(numBars * 4)
                let x = beatFraction * width
                
                let tickHeight: CGFloat = (beat % 4 == 0) ? 6 : 3
                var tickPath = Path()
                tickPath.move(to: CGPoint(x: x, y: height - tickHeight))
                tickPath.addLine(to: CGPoint(x: x, y: height))
                context.stroke(
                    tickPath,
                    with: .color(DesignSystem.Colors.textSecondary.opacity(0.4)),
                    lineWidth: 0.5
                )
            }
        }
        .frame(height: 34)
        .background(DesignSystem.Colors.surface)
        .border(width: 1, edges: [.bottom], color: DesignSystem.Colors.border)
    }
}

#Preview {
    SongTimelineCanvas()
        .environmentObject(AppState())
        .frame(height: 34)
}
