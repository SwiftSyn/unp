import Foundation

struct CommunityMessageDTO: Codable {
    let id: String
    let senderId: String
    let senderName: String
    let senderAvatarURL: String?
    let content: String
    let timestamp: String
    let eventId: String?

    func toDomain() -> CommunityMessage {
        CommunityMessage(
            id: id,
            senderId: senderId,
            senderName: senderName,
            senderAvatarURL: senderAvatarURL,
            content: content,
            timestamp: ISO8601DateFormatter().date(from: timestamp) ?? Date(),
            eventId: eventId
        )
    }
}
