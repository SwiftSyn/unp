import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: Data?

    private static let baseURL = "https://api.untilthenextpour.app/v1"

    var urlRequest: URLRequest {
        var components = URLComponents(string: Self.baseURL + path)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

extension Endpoint {
    static func getBeverages() -> Endpoint {
        Endpoint(path: "/beverages", method: .get, queryItems: nil, body: nil)
    }

    static func getEvents() -> Endpoint {
        Endpoint(path: "/events", method: .get, queryItems: nil, body: nil)
    }

    static func getVenues() -> Endpoint {
        Endpoint(path: "/venues", method: .get, queryItems: nil, body: nil)
    }

    static func getBartenders() -> Endpoint {
        Endpoint(path: "/bartenders", method: .get, queryItems: nil, body: nil)
    }

    static func getPosts() -> Endpoint {
        Endpoint(path: "/feed", method: .get, queryItems: nil, body: nil)
    }

    static func getReward(userId: String) -> Endpoint {
        Endpoint(path: "/rewards/\(userId)", method: .get, queryItems: nil, body: nil)
    }

    static func getRewardCatalog() -> Endpoint {
        Endpoint(path: "/rewards/catalog", method: .get, queryItems: nil, body: nil)
    }

    static func redeemReward(rewardId: String, userId: String) -> Endpoint {
        let body = try? JSONEncoder().encode(["rewardId": rewardId, "userId": userId])
        return Endpoint(path: "/rewards/redeem", method: .post, queryItems: nil, body: body)
    }
}
