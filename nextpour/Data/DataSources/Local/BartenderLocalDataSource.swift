import CoreData
import Foundation

final class BartenderLocalDataSource {
    private let context: NSManagedObjectContext
    private let dec = JSONDecoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [BartenderDTO] {
        let request = NSFetchRequest<NPBartender>(entityName: "NPBartender")
        return try context.fetch(request).map {
            let specialties = (try? dec.decode([String].self, from: Data(($0.specialties ?? "[]").utf8))) ?? []
            return BartenderDTO(id: $0.id ?? "", name: $0.name ?? "",
                                specialties: specialties, rating: $0.rating,
                                imageURL: $0.imageURL, isVerified: $0.isVerified,
                                bio: $0.bio ?? "", yearsExperience: Int($0.yearsExperience))
        }
    }
}
