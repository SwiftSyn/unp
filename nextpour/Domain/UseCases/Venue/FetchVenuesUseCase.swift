import Foundation

final class FetchVenuesUseCase {
    private let repository: VenueRepositoryProtocol

    init(repository: VenueRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Venue] {
        try await repository.fetchAll()
    }
}
