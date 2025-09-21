//
//  NotificationService.swift
//  Just In Time
//
//  Created by Antoine LEPRETRE on 21/09/2025.
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Erreur autorisation notifications : \(error.localizedDescription)")
            } else {
                print("Autorisation notifications : \(granted)")
            }
        }
    }

    func scheduleAlarm(_ alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarme"
        content.body = "C’est l’heure !"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur planification alarme : \(error.localizedDescription)")
            } else {
                print("Alarme planifiée pour \(alarm.time)")
            }
        }
    }

    func cancelAlarm(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    func cancelAllAlarms() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
