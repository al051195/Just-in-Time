//
//  StopwatchViewModel.swift
//  Just in Time
//
//  Created by Antoine LEPRETRE on 18/08/2025.
//

import Foundation
import Combine

final class StopwatchViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var startDate: Date?
    @Published var elapsedBeforePause: TimeInterval = 0
    @Published var laps: [Lap] = [] {
        didSet { PersistenceService.save(laps, to: "laps.json") }
    }

    private var ticker: AnyCancellable?
    @Published var now: Date = .init()
    
    /// Progression du chronomètre (0 → 1)
    @Published var progress: Double = 0.0

    var elapsed: TimeInterval {
        if let startDate, isRunning {
            return elapsedBeforePause + Date().timeIntervalSince(startDate)
        }
        return elapsedBeforePause
    }

    init() {
        laps = PersistenceService.load([Lap].self, from: "laps.json", fallback: [])
        ticker = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
            .sink { [weak self] date in
                guard let self else { return }
                self.now = date
                self.updateProgress()
            }
    }

    func start() {
        guard !isRunning else { return }
        startDate = Date()
        isRunning = true
        Haptics.tap()
    }

    func stop() {
        guard isRunning else { return }
        elapsedBeforePause = elapsed
        isRunning = false
        Haptics.warning()
    }

    func reset() {
        isRunning = false
        startDate = nil
        elapsedBeforePause = 0
        laps.removeAll()
        progress = 0.0
    }

    func addLap() {
        let index = laps.count + 1
        let lap = Lap(index: index, interval: lapInterval(), total: elapsed, date: Date())
        laps.insert(lap, at: 0)
    }

    private func lapInterval() -> TimeInterval {
        let lastTotal = laps.first?.total ?? 0
        return max(0, elapsed - lastTotal)
    }
    
    private func updateProgress() {
        // On fait une "progression infinie" (modulo sur 60 secondes par ex.)
        let cycle = 60.0
        progress = (elapsed.truncatingRemainder(dividingBy: cycle)) / cycle
    }
}

