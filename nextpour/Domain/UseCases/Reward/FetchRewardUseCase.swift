import Foundation

final class FetchRewardUseCase {
    private let repository: RewardRepositoryProtocol

    init(repository: RewardRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws -> Reward? {
        try await repository.fetchReward(forUserId: userId)
    }
}
