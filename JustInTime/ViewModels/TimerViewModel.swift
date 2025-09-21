import Foundation
import Combine

enum TimerState { case stopped, running, paused, finished }

final class TimerViewModel: ObservableObject {
    @Published var totalTime: TimeInterval = 60
    @Published var remainingTime: TimeInterval = 60
    @Published var timerState: TimerState = .stopped
    @Published var numberOfTimers: Int = 1
    @Published var currentRepetition: Int = 0
    
    private var startDate: Date?
    private var ticker: AnyCancellable?
    
    var sliderStep: TimeInterval { 15 }
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return remainingTime / totalTime
    }
    
    func formatTime(_ t: TimeInterval) -> String {
        let m = Int(t) / 60
        let s = Int(t) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    init() {
        remainingTime = totalTime
        ticker = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        guard timerState == .running, let start = startDate else { return }
        let elapsed = Date().timeIntervalSince(start)
        remainingTime = max(0, totalTime - elapsed)
        if remainingTime <= 0 {
            timerState = .finished
            stop()
        }
    }
    
    func start() {
        if timerState == .running { return }
        startDate = Date()
        timerState = .running
    }
    
    func stop() {
        timerState = .stopped
    }
    
    func reset() {
        timerState = .stopped
        remainingTime = totalTime
        currentRepetition = 0
    }
}
