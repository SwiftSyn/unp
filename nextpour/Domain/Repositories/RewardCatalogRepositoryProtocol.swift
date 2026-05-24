import Foundation

protocol RewardCatalogRepositoryProtocol {
    func fetchCatalog() async throws -> [RewardCatalogItem]
}
