import Foundation

struct BartenderClass: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let instructorName: String
    let durationMinutes: Int
    let isLocked: Bool
    let attendeeCount: Int
    let imageURL: String?
    let category: String
}
