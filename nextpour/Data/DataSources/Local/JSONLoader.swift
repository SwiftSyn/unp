import Foundation

enum JSONLoaderError: Error {
    case fileNotFound(String)
    case decodingFailed(Error)
}

struct JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONLoaderError.fileNotFound(filename)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw JSONLoaderError.decodingFailed(error)
        }
    }
}
