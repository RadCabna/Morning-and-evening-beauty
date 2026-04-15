import SwiftUI
import Combine

final class RitualExecutionViewModel: ObservableObject {
    let template: RitualTemplate

    @Published var isStarted: Bool = false
    @Published var completedSteps: Set<Int> = []
    @Published var timeRemaining: TimeInterval

    private var savedElapsed: Double
    private var currentElapsed: Double = 0
    private var timerCancellable: AnyCancellable?

    init(template: RitualTemplate, session: RitualSession? = nil) {
        self.template = template
        if let session {
            self.completedSteps = Set(session.completedStepIndices)
            self.savedElapsed = session.elapsedSeconds
            self.timeRemaining = max(0, template.totalDuration - session.elapsedSeconds)
        } else {
            self.savedElapsed = 0
            self.timeRemaining = template.totalDuration
        }
    }

    var totalDuration: TimeInterval { template.totalDuration }

    var totalTimeFormatted: String {
        let mins = Int(totalDuration) / 60
        let secs = Int(totalDuration) % 60
        if mins == 0 { return "\(secs) sec" }
        if secs == 0 { return "\(mins) min" }
        return "\(mins) min \(secs) sec"
    }

    var countdownFormatted: String {
        let total = max(0, Int(timeRemaining))
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }

    var currentStepIndex: Int? {
        template.steps.indices.first { !completedSteps.contains($0) }
    }

    var currentStep: RitualStep? {
        guard let idx = currentStepIndex else { return nil }
        return template.steps[idx]
    }

    var isAllStepsCompleted: Bool {
        completedSteps.count >= template.steps.count
    }

    var hasProgress: Bool {
        savedElapsed > 0 || !completedSteps.isEmpty
    }

    func start() {
        isStarted = true
        startTimer()
    }

    func pause() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func resume() {
        guard isStarted else { return }
        startTimer()
    }

    func completeCurrentStep() {
        guard let idx = currentStepIndex else { return }
        completedSteps.insert(idx)
    }

    func saveSession() {
        let totalElapsed = savedElapsed + currentElapsed
        guard totalElapsed > 0 || !completedSteps.isEmpty else { return }
        var session = RitualSessionStore.shared.session(for: template.id)
            ?? RitualSession(templateId: template.id)
        session.completedStepIndices = Array(completedSteps)
        session.elapsedSeconds = totalElapsed
        session.lastActiveAt = Date()
        session.isFinished = isAllStepsCompleted
        RitualSessionStore.shared.save(session)
    }

    func finishRitual(onComplete: (RitualCompletion) -> Void) {
        timerCancellable?.cancel()
        saveSession()
        RitualSessionStore.shared.markFinished(templateId: template.id)
        let completion = RitualCompletion(
            id: UUID(),
            ritualName: template.name,
            timeOfDay: template.timeOfDay,
            completedAt: Date()
        )
        CompletionStore.shared.record(completion)
        onComplete(completion)
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                currentElapsed += 1
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerCancellable?.cancel()
                }
            }
    }

    deinit {
        timerCancellable?.cancel()
    }
}
