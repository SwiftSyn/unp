import Foundation

struct PourCircleDTO: Codable {
    let id: String
    let name: String
    let description: String
    let memberCount: Int
    let imageURL: String?
    let lastActivity: String
    let isMember: Bool

    func toDomain() -> PourCircle {
        PourCircle(
            id: id,
            name: name,
            description: description,
            memberCount: memberCount,
            imageURL: imageURL,
            lastActivity: ISO8601DateFormatter().date(from: lastActivity) ?? Date(),
            isMember: isMember
        )
    }
}
