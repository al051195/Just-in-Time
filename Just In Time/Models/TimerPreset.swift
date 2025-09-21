import Foundation

struct TimerPreset: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var seconds: Int
}
