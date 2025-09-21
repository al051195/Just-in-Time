//
//  TimerViewModel.swift
//  Just in Time
//
//  Created by Antoine LEPRETRE on 18/08/2025.
//

import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var duration: TimeInterval = 60 // durée totale en secondes (par défaut 1 min)
    @Published private var elapsed: TimeInterval = 0
    
    private var startDate: Date?
    private var ticker: AnyCancellable?
    
    var remainingTime: TimeInterval {
        max(0, duration - elapsed)
    }
    
    var progress: Double {
        guard duration > 0 else { return 0 }
        return remainingTime / duration
    }
    
    init() {
        ticker = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.updateElapsed(at: date)
            }
    }
    
    private func updateElapsed(at date: Date) {
        guard isRunning, let startDate else { return }
        elapsed = Date().timeIntervalSince(startDate)
        if elapsed >= duration {
            stop()
            Haptics.warning()
        }
    }
    
    func start() {
        guard !isRunning else { return }
        startDate = Date()
        isRunning = true
        Haptics.tap()
    }
    
    func stop() {
        isRunning = false
    }
    
    func reset() {
        isRunning = false
        startDate = nil
        elapsed = 0
    }
}

