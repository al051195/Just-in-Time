import Foundation

enum PersistenceService {
    static func save<T: Codable>(_ value: T, to filename: String) {
        let url = fileURL(filename)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Save error \(filename):", error)
        }
    }

    static func load<T: Codable>(_ type: T.Type, from filename: String, fallback: T) -> T {
        let url = fileURL(filename)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return fallback
        }
    }

    private static func fileURL(_ filename: String) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(filename)
    }
}
