import Foundation

struct PourCircle: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let memberCount: Int
    let imageURL: String?
    let lastActivity: Date
    var isMember: Bool
}
