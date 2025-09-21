// LiquidGlassClockApp.swift
import SwiftUI

@main
struct LiquidGlassClockApp: App {
    @StateObject private var alarmsVM = AlarmsViewModel()
    @StateObject private var timerVM = TimerViewModel()
    @StateObject private var stopwatchVM = StopwatchViewModel()

    init() {
        NotificationService.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alarmsVM)
                .environmentObject(timerVM)
                .environmentObject(stopwatchVM)
        }
    }
}

