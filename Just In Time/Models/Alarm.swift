import Foundation
import SwiftUI

struct Alarm: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var time: Date
    var label: String = "Alarme"
    var enabled: Bool = true
    /// Jours actifs (0 = Dimanche ... 6 = Samedi) ; vide = une seule fois
    var repeatDays: Set<Int> = []
    var soundName: String = "Default"
    var vibrate: Bool = true
}
