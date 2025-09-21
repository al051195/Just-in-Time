import Foundation

enum PersistenceService {
    static func save<T: Encodable>(_ value: T, to filename: String) {
        // placeholder
    }
    static func load<T: Decodable>(_ type: T.Type, from filename: String, fallback: T) -> T {
        return fallback
    }
}
