import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleAlarm(_ alarm: Alarm) {
        cancelAlarm(id: alarm.id)

        let content = UNMutableNotificationContent()
        content.title = alarm.label.isEmpty ? "Alarme" : alarm.label
        content.body = "C'est l'heure ⏰"
        content.sound = .default

        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: alarm.time)

        if alarm.repeatDays.isEmpty {
            var dateComp = DateComponents()
            dateComp.hour = comps.hour
            dateComp.minute = comps.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            for weekday in alarm.repeatDays {
                var dateComp = DateComponents()
                dateComp.weekday = weekday == 0 ? 1 : weekday + 1 // Calendar: 1=Dimanche
                dateComp.hour = comps.hour
                dateComp.minute = comps.minute
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                let id = "\(alarm.id.uuidString)-\(weekday)"
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    func cancelAlarm(id: UUID) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let ids = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(id.uuidString) }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        }
    }
}
