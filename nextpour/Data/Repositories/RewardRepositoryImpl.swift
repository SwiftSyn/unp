import Foundation

final class RewardRepositoryImpl: RewardRepositoryProtocol {
    private let localDataSource: RewardLocalDataSource

    init(localDataSource: RewardLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchReward(forUserId userId: String) async throws -> Reward? {
        try localDataSource.fetchAll().first { $0.userId == userId }?.toDomain()
    }
}
