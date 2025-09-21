import Foundation

struct Lap: Identifiable, Codable, Equatable {
    let id = UUID()
    let index: Int
    let interval: TimeInterval
    let total: TimeInterval
    let date: Date
}
