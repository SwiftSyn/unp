import CoreData
import Foundation

final class VenueLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [VenueDTO] {
        let request = NSFetchRequest<NPVenue>(entityName: "NPVenue")
        return try context.fetch(request).map {
            VenueDTO(id: $0.id ?? "", name: $0.name ?? "",
                     address: $0.address ?? "", imageURL: $0.imageURL,
                     rating: $0.rating, category: $0.category ?? "",
                     distanceMiles: $0.distanceMiles, isOpen: $0.isOpen)
        }
    }
}
