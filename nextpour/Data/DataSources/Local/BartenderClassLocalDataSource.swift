import CoreData
import Foundation

final class BartenderClassLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [BartenderClassDTO] {
        let request = NSFetchRequest<NPBartenderClass>(entityName: "NPBartenderClass")
        return try context.fetch(request).map {
            BartenderClassDTO(id: $0.id ?? "", title: $0.title ?? "",
                              description: $0.classDescription ?? "",
                              instructorName: $0.instructorName ?? "",
                              durationMinutes: Int($0.durationMinutes),
                              isLocked: $0.isLocked,
                              attendeeCount: Int($0.attendeeCount),
                              imageURL: $0.imageURL, category: $0.category ?? "")
        }
    }
}
