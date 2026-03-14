//
//  SequencerView.swift
//  Torso S4 Controller
//

import SwiftUI

// MARK: - Models
struct Step: Identifiable {
    let id = UUID()
    var isActive: Bool = false
    var isPlaying: Bool = false
}

struct Lane: Identifiable {
    let id = UUID()
    var steps: [Step]

    init(stepCount: Int = 16) {
        steps = Array(repeating: Step(), count: stepCount)
    }

    mutating func updateStepCount(_ newCount: Int) {
        if newCount > steps.count {
            steps.append(contentsOf: Array(repeating: Step(), count: newCount - steps.count))
        } else if newCount < steps.count {
            steps.removeLast(steps.count - newCount)
        }
    }
}

// MARK: - Sequencer View
struct SequencerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        GeometryReader { geo in
            let maxWidth = geo.size.width - 32
            VStack(spacing: 12) {
                // Step Count Control
                HStack {
                    Text("Steps:")
                    let stepCountBinding = Binding(
                        get: { appState.stepCount },
                        set: { appState.stepCount = $0 }
                    )
                    TextField("Number of steps", value: stepCountBinding, formatter: NumberFormatter())
                        .frame(width: 60)
                        .textFieldStyle(.roundedBorder)
                    Button("+") { stepCountBinding.wrappedValue += 1 }
                    Button("-") { stepCountBinding.wrappedValue = max(1, stepCountBinding.wrappedValue - 1) }
                    Spacer()
                }
                .padding(.horizontal)

                // Lanes
                ForEach(appState.lanes.indices, id: \.self) { laneIndex in
                    let laneBinding = Binding<Lane>(
                        get: { appState.lanes[laneIndex] },
                        set: { appState.lanes[laneIndex] = $0 }
                    )
                    SequencerLaneView(lane: laneBinding, maxWidth: maxWidth)
                }
            }
            .padding(.vertical)
        }
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { _ in
            appState.transportTick()
        }
    }
}

// MARK: - Sequencer Lane View
struct SequencerLaneView: View {
    @Binding var lane: Lane
    let maxWidth: CGFloat
    @State private var isDragging = false
    @State private var paintState: Bool = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 2) {
                ForEach(lane.steps.indices, id: \.self) { stepIndex in
                    let stepBinding = Binding<Step>(
                        get: { lane.steps[stepIndex] },
                        set: { lane.steps[stepIndex] = $0 }
                    )
                    Rectangle()
                        .fill(stepBinding.wrappedValue.isPlaying ? Color.yellow : (stepBinding.wrappedValue.isActive ? Color.green : Color.gray))
                        .frame(width: stepWidth, height: 24)
                        .cornerRadius(2)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !isDragging {
                                        paintState = !stepBinding.wrappedValue.isActive
                                        isDragging = true
                                    }
                                    stepBinding.wrappedValue.isActive = paintState
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                        .onTapGesture { stepBinding.wrappedValue.isActive.toggle() }
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var stepWidth: CGFloat {
        let totalSpacing = CGFloat(max(0, lane.steps.count - 1)) * 2
        return max((maxWidth - totalSpacing) / CGFloat(lane.steps.count), 20)
    }
}

// MARK: - Preview
#Preview {
    SequencerView().environmentObject(AppState())
}
