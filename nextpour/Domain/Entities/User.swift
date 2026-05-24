import Foundation

enum UserRole: String, Codable {
    case consumer, bartender, venue
}

enum RewardTier: String, Codable {
    case bronze, silver, gold

    var minimumPoints: Int {
        switch self {
        case .bronze: return 0
        case .silver: return 500
        case .gold: return 1500
        }
    }

    var displayName: String { rawValue.capitalized }
}

struct User: Identifiable, Equatable {
    let id: String
    let name: String
    let email: String
    let role: UserRole
    let avatarURL: String?
    let bio: String
    let isAmbassador: Bool
    let rewardPoints: Int
    let rewardTier: RewardTier
}
