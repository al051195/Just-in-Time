import Foundation
import Combine

enum TimerState {
    case stopped
    case running
    case paused
    case finished
}

final class TimerViewModel: ObservableObject {
    @Published var totalTime: Double = 60 { // durée d'un timer en secondes
        didSet {
            // si le timer est arrêté, on reset automatiquement remainingTime
            if timerState == .stopped {
                remainingTime = totalTime
            }
        }
    }
    @Published var remainingTime: Double = 60
    @Published var numberOfTimers: Int = 1
    @Published var currentRepetition: Int = 0
    @Published var timerState: TimerState = .stopped
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // pas inférieur à 5 sec pour éviter 0 instantané
    var sliderStep: Double { 5 }

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return max(0, min(1, remainingTime / totalTime))
    }
    
    // MARK: - Actions
    
    func start() {
        guard totalTime > 0 else { return }
        
        if currentRepetition == 0 { currentRepetition = 1 }
        timerState = .running
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        timerState = .paused
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        remainingTime = totalTime
        currentRepetition = 0
        timerState = .stopped
    }
    
    private func tick() {
        guard remainingTime > 0 else {
            timer?.invalidate()
            if currentRepetition < numberOfTimers {
                // passe au timer suivant
                currentRepetition += 1
                remainingTime = totalTime
                start()
            } else {
                // tout est fini
                timerState = .finished
                currentRepetition = 0
            }
            return
        }
        
        remainingTime -= 1
    }
    
    // MARK: - Format
    
    func formatTime(_ seconds: Double) -> String {
        let intVal = Int(seconds)
        let minutes = intVal / 60
        let secs = intVal % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

