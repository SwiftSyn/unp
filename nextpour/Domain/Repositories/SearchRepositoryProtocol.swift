import Foundation

struct SearchResults: Equatable {
    let beverages: [Beverage]
    let events: [Event]
    let venues: [Venue]
    let bartenders: [Bartender]
}

protocol SearchRepositoryProtocol {
    func search(query: String) async throws -> SearchResults
}
