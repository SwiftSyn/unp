import CoreData
import Foundation

final class RewardLocalDataSource {
    private let context: NSManagedObjectContext
    private let dec = JSONDecoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [RewardDTO] {
        let request = NSFetchRequest<NPReward>(entityName: "NPReward")
        return try context.fetch(request).map {
            let history = (try? dec.decode([RewardTransactionDTO].self, from: Data(($0.historyJSON ?? "[]").utf8))) ?? []
            return RewardDTO(id: $0.id ?? "", userId: $0.userId ?? "",
                             tier: $0.tier ?? "bronze", points: Int($0.points),
                             history: history)
        }
    }
}
