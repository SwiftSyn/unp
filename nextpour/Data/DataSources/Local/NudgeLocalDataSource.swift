import CoreData
import Foundation

final class NudgeLocalDataSource {
    private let context: NSManagedObjectContext
    private let fmt = ISO8601DateFormatter()
    private let dec = JSONDecoder()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [NudgeDTO] {
        let request = NSFetchRequest<NPNudge>(entityName: "NPNudge")
        return try context.fetch(request).map {
            let expiresStr = $0.expiresAt.map { fmt.string(from: $0) } ?? ""
            let options = (try? dec.decode([NudgeOptionDTO].self, from: Data(($0.optionsJSON ?? "[]").utf8))) ?? []
            return NudgeDTO(id: $0.id ?? "", question: $0.question ?? "",
                            options: options, expiresAt: expiresStr)
        }
    }
}
