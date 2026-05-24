import CoreData
import Foundation

final class PostLocalDataSource {
    private let context: NSManagedObjectContext
    private let fmt = ISO8601DateFormatter()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [PostDTO] {
        let request = NSFetchRequest<NPPost>(entityName: "NPPost")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(request).map {
            let ts = $0.timestamp.map { fmt.string(from: $0) } ?? ""
            return PostDTO(id: $0.id ?? "", authorId: $0.authorId ?? "",
                           authorName: $0.authorName ?? "",
                           authorAvatarURL: $0.authorAvatarURL,
                           content: $0.content ?? "", imageURL: $0.imageURL,
                           likeCount: Int($0.likeCount),
                           commentCount: Int($0.commentCount),
                           timestamp: ts, drinkTag: $0.drinkTag,
                           isLiked: $0.isLiked)
        }
    }
}
