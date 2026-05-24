import Foundation

final class SearchRepositoryImpl: SearchRepositoryProtocol {
    private let beverageRepository: BeverageRepositoryProtocol
    private let eventRepository: EventRepositoryProtocol
    private let venueRepository: VenueRepositoryProtocol
    private let bartenderRepository: BartenderRepositoryProtocol

    init(
        beverageRepository: BeverageRepositoryProtocol,
        eventRepository: EventRepositoryProtocol,
        venueRepository: VenueRepositoryProtocol,
        bartenderRepository: BartenderRepositoryProtocol
    ) {
        self.beverageRepository = beverageRepository
        self.eventRepository = eventRepository
        self.venueRepository = venueRepository
        self.bartenderRepository = bartenderRepository
    }

    func search(query: String) async throws -> SearchResults {
        let q = query.lowercased()
        async let beverages = beverageRepository.fetchAll()
        async let events = eventRepository.fetchAll()
        async let venues = venueRepository.fetchAll()
        async let bartenders = bartenderRepository.fetchAll()
        return try await SearchResults(
            beverages: beverages.filter { $0.name.lowercased().contains(q) },
            events: events.filter { $0.title.lowercased().contains(q) || $0.venueName.lowercased().contains(q) },
            venues: venues.filter { $0.name.lowercased().contains(q) },
            bartenders: bartenders.filter { $0.name.lowercased().contains(q) }
        )
    }
}
