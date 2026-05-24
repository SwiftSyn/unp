import Foundation

final class SearchContentUseCase {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> SearchResults {
        guard query.count >= 2 else { return SearchResults(beverages: [], events: [], venues: [], bartenders: []) }
        return try await repository.search(query: query)
    }
}
