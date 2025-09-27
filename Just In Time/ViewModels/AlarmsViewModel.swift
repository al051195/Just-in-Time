import Foundation
import Combine
import SwiftUI

struct Alarm: Identifiable, Codable, Equatable {
    let id: UUID
    var time: Date
    var enabled: Bool
}

final class AlarmsViewModel: ObservableObject {
    
    @Published var alarms: [Alarm] = []
    
    func add(_ alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func update(_ alarm: Alarm) {
        if let idx = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[idx] = alarm
        }
    }
    
    func delete(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}
