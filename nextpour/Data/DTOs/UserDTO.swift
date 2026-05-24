import Foundation

struct UserDTO: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
    let avatarURL: String?
    let bio: String
    let isAmbassador: Bool
    let rewardPoints: Int
    let rewardTier: String

    func toDomain() -> User {
        User(
            id: id,
            name: name,
            email: email,
            role: UserRole(rawValue: role) ?? .consumer,
            avatarURL: avatarURL,
            bio: bio,
            isAmbassador: isAmbassador,
            rewardPoints: rewardPoints,
            rewardTier: RewardTier(rawValue: rewardTier) ?? .bronze
        )
    }
}
