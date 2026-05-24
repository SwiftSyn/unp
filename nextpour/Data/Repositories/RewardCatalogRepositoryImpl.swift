import Foundation

final class RewardCatalogRepositoryImpl: RewardCatalogRepositoryProtocol {
    private let localDataSource: RewardCatalogLocalDataSource

    init(localDataSource: RewardCatalogLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchCatalog() async throws -> [RewardCatalogItem] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }
}
