import Foundation

final class FetchEventsUseCase {
    private let repository: EventRepositoryProtocol

    init(repository: EventRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Event] {
        try await repository.fetchAll()
    }

    func executeFeatured() async throws -> [Event] {
        try await repository.fetchFeatured()
    }
}
