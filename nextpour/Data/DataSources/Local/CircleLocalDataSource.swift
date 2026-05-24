import CoreData
import Foundation

final class CircleLocalDataSource {
    private let context: NSManagedObjectContext
    private let fmt = ISO8601DateFormatter()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [PourCircleDTO] {
        let request = NSFetchRequest<NPPourCircle>(entityName: "NPPourCircle")
        return try context.fetch(request).map {
            let lastActivity = $0.lastActivity.map { fmt.string(from: $0) } ?? ""
            return PourCircleDTO(id: $0.id ?? "", name: $0.name ?? "",
                                 description: $0.circleDescription ?? "",
                                 memberCount: Int($0.memberCount),
                                 imageURL: $0.imageURL,
                                 lastActivity: lastActivity,
                                 isMember: $0.isMember)
        }
    }
}
