import SwiftUI
import UserNotifications

@main
struct JustInTimeApp: App {
    @StateObject private var alarmsVM = AlarmsViewModel()
    @StateObject private var timerVM = TimerViewModel()
    @StateObject private var stopwatchVM = StopwatchViewModel()

    init() {
        // Demande d'autorisation pour les notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission for notifications :\(error.localizedDescription)")
            } else {
                print("Notification authorization : \(granted ? "Granted" : "Refused")")
            }
        }
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

