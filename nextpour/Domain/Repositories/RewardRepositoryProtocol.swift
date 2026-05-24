import Foundation

protocol RewardRepositoryProtocol {
    func fetchReward(forUserId userId: String) async throws -> Reward?
}
