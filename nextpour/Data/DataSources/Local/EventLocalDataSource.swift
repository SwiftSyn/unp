import CoreData
import Foundation

final class EventLocalDataSource {
    private let context: NSManagedObjectContext
    private let fmt = ISO8601DateFormatter()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [EventDTO] {
        let request = NSFetchRequest<NPEvent>(entityName: "NPEvent")
        return try context.fetch(request).map {
            let dateStr = $0.date.map { fmt.string(from: $0) } ?? ""
            return EventDTO(id: $0.id ?? "", title: $0.title ?? "",
                            description: $0.eventDescription ?? "",
                            venueName: $0.venueName ?? "",
                            venueAddress: $0.venueAddress ?? "",
                            date: dateStr, imageURL: $0.imageURL,
                            category: $0.category ?? "social",
                            attendeeCount: Int($0.attendeeCount),
                            isFeatured: $0.isFeatured)
        }
    }
}
