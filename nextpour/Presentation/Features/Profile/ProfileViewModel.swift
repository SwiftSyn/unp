import Foundation

@Observable
final class ProfileViewModel {
    private(set) var user: User?
    private(set) var reward: Reward?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var showAuraPortal = false

    private let fetchCurrentUserUseCase: FetchCurrentUserUseCase
    private let fetchRewardUseCase: FetchRewardUseCase

    init(fetchCurrentUserUseCase: FetchCurrentUserUseCase, fetchRewardUseCase: FetchRewardUseCase) {
        self.fetchCurrentUserUseCase = fetchCurrentUserUseCase
        self.fetchRewardUseCase = fetchRewardUseCase
    }

    var progressToNextTier: Double {
        guard let reward = reward else { return 0 }
        let current = reward.tier
        let nextMin: Int
        switch current {
        case .bronze: nextMin = RewardTier.silver.minimumPoints
        case .silver: nextMin = RewardTier.gold.minimumPoints
        case .gold: return 1.0
        }
        let base = current.minimumPoints
        return min(1.0, Double(reward.points - base) / Double(nextMin - base))
    }

    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            user = try await fetchCurrentUserUseCase.execute()
            if let userId = user?.id {
                reward = try await fetchRewardUseCase.execute(userId: userId)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
