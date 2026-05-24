import Foundation

final class FetchRewardCatalogUseCase {
    private let repository: RewardCatalogRepositoryProtocol

    init(repository: RewardCatalogRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [RewardCatalogItem] {
        try await repository.fetchCatalog()
    }
}
