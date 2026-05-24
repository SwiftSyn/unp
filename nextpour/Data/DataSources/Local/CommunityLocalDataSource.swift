import CoreData
import Foundation

final class CommunityLocalDataSource {
    private let context: NSManagedObjectContext
    private let fmt = ISO8601DateFormatter()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [CommunityMessageDTO] {
        let request = NSFetchRequest<NPCommunityMessage>(entityName: "NPCommunityMessage")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return try context.fetch(request).map {
            let ts = $0.timestamp.map { fmt.string(from: $0) } ?? ""
            return CommunityMessageDTO(id: $0.id ?? "", senderId: $0.senderId ?? "",
                                       senderName: $0.senderName ?? "",
                                       senderAvatarURL: $0.senderAvatarURL,
                                       content: $0.content ?? "",
                                       timestamp: ts, eventId: $0.eventId)
        }
    }
}
