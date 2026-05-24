import CoreData
import Foundation

final class UserLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [UserDTO] {
        let request = NSFetchRequest<NPUser>(entityName: "NPUser")
        return try context.fetch(request).map {
            UserDTO(id: $0.id ?? "", name: $0.name ?? "", email: $0.email ?? "",
                    role: $0.role ?? "consumer", avatarURL: $0.avatarURL,
                    bio: $0.bio ?? "", isAmbassador: $0.isAmbassador,
                    rewardPoints: Int($0.rewardPoints), rewardTier: $0.rewardTier ?? "bronze")
        }
    }
}
