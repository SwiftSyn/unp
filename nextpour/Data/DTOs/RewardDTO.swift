import Foundation

struct RewardTransactionDTO: Codable {
    let id: String
    let description: String
    let points: Int
    let date: String

    func toDomain() -> RewardTransaction {
        RewardTransaction(
            id: id,
            description: description,
            points: points,
            date: ISO8601DateFormatter().date(from: date) ?? Date()
        )
    }
}

struct RewardDTO: Codable {
    let id: String
    let userId: String
    let tier: String
    let points: Int
    let history: [RewardTransactionDTO]

    func toDomain() -> Reward {
        Reward(
            id: id,
            userId: userId,
            tier: RewardTier(rawValue: tier) ?? .bronze,
            points: points,
            history: history.map { $0.toDomain() }
        )
    }
}
