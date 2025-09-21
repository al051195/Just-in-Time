import Foundation
import Combine
import SwiftUI

final class AlarmsViewModel: ObservableObject {
    @Published var alarms: [Alarm] = [] {
        didSet { PersistenceService.save(alarms, to: "alarms.json") }
    }

    init() {
        self.alarms = PersistenceService.load([Alarm].self, from: "alarms.json", fallback: [])
    }

    func toggle(_ alarm: Alarm) {
        guard let idx = alarms.firstIndex(of: alarm) else { return }
        alarms[idx].enabled.toggle()
        if alarms[idx].enabled {
            NotificationService.shared.scheduleAlarm(alarms[idx])
        } else {
            NotificationService.shared.cancelAlarm(id: alarm.id)
        }
    }

    func add(_ alarm: Alarm) {
        alarms.append(alarm)
        if alarm.enabled { NotificationService.shared.scheduleAlarm(alarm) }
    }

    func update(_ alarm: Alarm) {
        guard let idx = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[idx] = alarm
        NotificationService.shared.scheduleAlarm(alarm)
    }

    func delete(at offsets: IndexSet) {
        for i in offsets {
            NotificationService.shared.cancelAlarm(id: alarms[i].id)
        }
        alarms.remove(atOffsets: offsets)
    }
}
