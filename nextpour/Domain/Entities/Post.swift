import Foundation

struct Post: Identifiable, Equatable {
    let id: String
    let authorId: String
    let authorName: String
    let authorAvatarURL: String?
    let content: String
    let imageURL: String?
    var likeCount: Int
    let commentCount: Int
    let timestamp: Date
    let drinkTag: String?
    var isLiked: Bool
}
