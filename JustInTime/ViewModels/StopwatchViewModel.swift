import Foundation
import Combine

final class StopwatchViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var startDate: Date?
    @Published var elapsedBeforePause: TimeInterval = 0
    @Published var laps: [TimeInterval] = []
    
    private var ticker: AnyCancellable?
    @Published var elapsed: TimeInterval = 0
    
    var formattedTime: String {
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        let ms = Int((elapsed.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, ms)
    }
    
    var elapsedTimeString: String { formattedTime }
    
    init() {
        ticker = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { [weak self] date in
            guard let self = self else { return }
            if let start = self.startDate, self.isRunning {
                self.elapsed = self.elapsedBeforePause + Date().timeIntervalSince(start)
            }
        }
    }
    
    func start() {
        guard !isRunning else { return }
        startDate = Date()
        isRunning = true
    }
    
    func stop() {
        guard isRunning else { return }
        elapsedBeforePause = elapsed
        isRunning = false
    }
    
    func reset() {
        isRunning = false
        startDate = nil
        elapsedBeforePause = 0
        elapsed = 0
        laps.removeAll()
    }
    
    func lap() {
        laps.insert(elapsed, at: 0)
    }
}
