import Foundation

final class DataCache {
    static let shared = DataCache()

    private let fileManager = FileManager.default
    private lazy var cacheDirectory: URL = {
        let dir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("nextpourDataCache", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func save<T: Encodable>(_ value: T, key: String) {
        let url = cacheDirectory.appendingPathComponent("\(key).json")
        try? encoder.encode(value).write(to: url, options: .atomic)
    }

    func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        let url = cacheDirectory.appendingPathComponent("\(key).json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    func clear(key: String) {
        let url = cacheDirectory.appendingPathComponent("\(key).json")
        try? fileManager.removeItem(at: url)
    }

    func clearAll() {
        try? fileManager.removeItem(at: cacheDirectory)
    }
}
