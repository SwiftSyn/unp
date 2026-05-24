import Foundation

@Observable
final class ExploreViewModel {
    private(set) var events: [Event] = []
    private(set) var venues: [Venue] = []
    private(set) var bartenders: [Bartender] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var selectedCategory: EventCategory?

    private let fetchEventsUseCase: FetchEventsUseCase
    private let fetchVenuesUseCase: FetchVenuesUseCase
    private let fetchBartendersUseCase: FetchBartendersUseCase

    init(
        fetchEventsUseCase: FetchEventsUseCase,
        fetchVenuesUseCase: FetchVenuesUseCase,
        fetchBartendersUseCase: FetchBartendersUseCase
    ) {
        self.fetchEventsUseCase = fetchEventsUseCase
        self.fetchVenuesUseCase = fetchVenuesUseCase
        self.fetchBartendersUseCase = fetchBartendersUseCase
    }

    var filteredEvents: [Event] {
        guard let category = selectedCategory else { return events }
        return events.filter { $0.category == category }
    }

    func loadData() async {
        isLoading = true
        errorMessage = nil
        do {
            async let events = fetchEventsUseCase.execute()
            async let venues = fetchVenuesUseCase.execute()
            async let bartenders = fetchBartendersUseCase.execute()
            (self.events, self.venues, self.bartenders) = try await (events, venues, bartenders)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
