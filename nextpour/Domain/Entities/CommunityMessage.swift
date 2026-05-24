import Foundation

struct CommunityMessage: Identifiable, Equatable {
    let id: String
    let senderId: String
    let senderName: String
    let senderAvatarURL: String?
    let content: String
    let timestamp: Date
    let eventId: String?
}
