import Foundation

final class RewardCatalogLocalDataSource {
    func fetchAll() throws -> [RewardCatalogItemDTO] {
        try JSONLoader.load("reward_catalog", as: [RewardCatalogItemDTO].self)
    }
}
