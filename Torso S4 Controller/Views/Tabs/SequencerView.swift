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
                stepCountControl

                ForEach(appState.lanes.indices, id: \.self) { laneIndex in
                    let laneBinding = Binding(
                        get: { appState.lanes[laneIndex] },
                        set: { appState.lanes[laneIndex] = $0 }
                    )
                    laneView(lane: laneBinding, maxWidth: maxWidth)
                }
            }
            .padding(.vertical)
        }
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { _ in
            appState.transportTick()
        }
    }

    private var stepCountControl: some View {
        HStack {
            Text("Steps:")
            TextField("Number of steps", value: Binding(
                get: { appState.stepCount },
                set: { appState.stepCount = $0 }
            ), formatter: NumberFormatter())
            .frame(width: 60)
            .textFieldStyle(.roundedBorder)
            Button("+") { appState.stepCount += 1 }
            Button("-") { appState.stepCount = max(1, appState.stepCount - 1) }
            Spacer()
        }
        .padding(.horizontal)
    }

    private func laneView(lane: Binding<Lane>, maxWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SequencerLaneView(lane: lane, maxWidth: maxWidth)
            HStack(spacing: 8) {
                Menu("Copy →") {
                    ForEach(appState.lanes.indices.filter { appState.lanes[$0].id != lane.wrappedValue.id }, id: \.self) { target in
                        Button("Lane \(target + 1)") { appState.copyLane(from: appState.lanes.firstIndex(where: { $0.id == lane.wrappedValue.id })!, to: target) }
                    }
                }
                Menu("Mirror →") {
                    ForEach(appState.lanes.indices.filter { appState.lanes[$0].id != lane.wrappedValue.id }, id: \.self) { target in
                        Button("Lane \(target + 1)") { appState.mirrorLane(from: appState.lanes.firstIndex(where: { $0.id == lane.wrappedValue.id })!, to: target) }
                    }
                }
                Spacer()
            }
            .font(.caption)
            .padding(.horizontal)
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
                ForEach($lane.steps) { $step in
                    Rectangle()
                        .fill(step.isPlaying ? Color.yellow : (step.isActive ? Color.green : Color.gray))
                        .frame(width: stepWidth, height: 24)
                        .cornerRadius(2)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !isDragging {
                                        paintState = !step.isActive
                                        isDragging = true
                                    }
                                    step.isActive = paintState
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                        .onTapGesture { step.isActive.toggle() }
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
