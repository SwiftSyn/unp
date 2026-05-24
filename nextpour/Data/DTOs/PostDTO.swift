import Foundation

struct PostDTO: Codable {
    let id: String
    let authorId: String
    let authorName: String
    let authorAvatarURL: String?
    let content: String
    let imageURL: String?
    let likeCount: Int
    let commentCount: Int
    let timestamp: String
    let drinkTag: String?
    let isLiked: Bool

    func toDomain() -> Post {
        Post(
            id: id,
            authorId: authorId,
            authorName: authorName,
            authorAvatarURL: authorAvatarURL,
            content: content,
            imageURL: imageURL,
            likeCount: likeCount,
            commentCount: commentCount,
            timestamp: ISO8601DateFormatter().date(from: timestamp) ?? Date(),
            drinkTag: drinkTag,
            isLiked: isLiked
        )
    }
}
