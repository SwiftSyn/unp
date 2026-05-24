import Foundation

struct RewardTransaction: Identifiable, Equatable {
    let id: String
    let description: String
    let points: Int
    let date: Date
}

struct Reward: Identifiable, Equatable {
    let id: String
    let userId: String
    let tier: RewardTier
    let points: Int
    let history: [RewardTransaction]
}
