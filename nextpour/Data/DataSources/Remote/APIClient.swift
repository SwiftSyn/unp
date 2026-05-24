import Foundation

enum APIError: Error, LocalizedError {
    case badResponse(Int)
    case noData
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .badResponse(let code): return "Server returned status \(code)"
        case .noData: return "No data received from server"
        case .decodingFailed(let error): return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

struct APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await session.data(for: endpoint.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIError.badResponse(code)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
