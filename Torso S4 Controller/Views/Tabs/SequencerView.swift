cd ~/Music/"Torso S4 Controller"

# Replace SequencerView.swift completely
cat > Torso\ S4\ Controller/Views/Tabs/SequencerView.swift << 'EOF'
import SwiftUI

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

class AppState: ObservableObject {
    @Published var lanes: [Lane] = Array(repeating: Lane(), count: 4)
    @Published var stepCount: Int = 16 {
        didSet { updateStepCountForAllLanes() }
    }
    @Published var currentStep: Int = 0

    func updateStepCountForAllLanes() {
        for index in lanes.indices {
            lanes[index].updateStepCount(stepCount)
        }
    }

    func transportTick() {
        currentStep = (currentStep + 1) % stepCount
        for laneIndex in lanes.indices {
            for stepIndex in lanes[laneIndex].steps.indices {
                lanes[laneIndex].steps[stepIndex].isPlaying = (stepIndex == currentStep)
            }
        }
    }
    
    func copyLane(from sourceIndex: Int, to targetIndex: Int) {
        guard lanes.indices.contains(sourceIndex), lanes.indices.contains(targetIndex) else { return }
        lanes[targetIndex].steps = lanes[sourceIndex].steps
    }

    func mirrorLane(from sourceIndex: Int, to targetIndex: Int) {
        guard lanes.indices.contains(sourceIndex), lanes.indices.contains(targetIndex) else { return }
        lanes[targetIndex].steps = lanes[sourceIndex].steps.map { step in
            Step(isActive: !step.isActive, isPlaying: step.isPlaying)
        }
    }
}

struct SequencerLaneView: View {
    @Binding var lane: Lane
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
        let maxWidth = UIScreen.main.bounds.width - 32
        return max((maxWidth - totalSpacing) / CGFloat(lane.steps.count), 20)
    }
}

struct SequencerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Steps:")
                TextField("Number of steps", value: $appState.stepCount, formatter: NumberFormatter())
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                Button("+") { appState.stepCount += 1 }
                Button("-") { appState.stepCount = max(1, appState.stepCount - 1) }
            }
            .padding(.horizontal)

            ForEach($appState.lanes.indices, id: \.self) { laneIndex in
                VStack(alignment: .leading, spacing: 4) {
                    SequencerLaneView(lane: $appState.lanes[laneIndex])

                    HStack(spacing: 8) {
                        Menu("Copy →") {
                            ForEach(appState.lanes.indices.filter { $0 != laneIndex }, id: \.self) { target in
                                Button("Lane \(target + 1)") { appState.copyLane(from: laneIndex, to: target) }
                            }
                        }
                        Menu("Mirror →") {
                            ForEach(appState.lanes.indices.filter { $0 != laneIndex }, id: \.self) { target in
                                Button("Lane \(target + 1)") { appState.mirrorLane(from: laneIndex, to: target) }
                            }
                        }
                        Spacer()
                    }
                    .font(.caption)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { _ in
            appState.transportTick()
        }
    }
}
EOF

