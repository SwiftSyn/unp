import CoreData
import Foundation

final class BeverageLocalDataSource {
    private let context: NSManagedObjectContext
    private let dec = JSONDecoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [BeverageDTO] {
        let request = NSFetchRequest<NPBeverage>(entityName: "NPBeverage")
        return try context.fetch(request).map {
            let ingredients = (try? dec.decode([String].self, from: Data(($0.ingredients ?? "[]").utf8))) ?? []
            let steps = (try? dec.decode([String].self, from: Data(($0.steps ?? "[]").utf8))) ?? []
            return BeverageDTO(id: $0.id ?? "", name: $0.name ?? "",
                               description: $0.beverageDescription ?? "",
                               imageURL: $0.imageURL, ingredients: ingredients,
                               steps: steps, category: $0.category ?? "classics",
                               rating: $0.rating, isAmbassadorUpload: $0.isAmbassadorUpload,
                               authorId: $0.authorId)
        }
    }
}
