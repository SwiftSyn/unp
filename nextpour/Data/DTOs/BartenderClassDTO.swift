import Foundation

struct BartenderClassDTO: Codable {
    let id: String
    let title: String
    let description: String
    let instructorName: String
    let durationMinutes: Int
    let isLocked: Bool
    let attendeeCount: Int
    let imageURL: String?
    let category: String

    func toDomain() -> BartenderClass {
        BartenderClass(id: id, title: title, description: description, instructorName: instructorName, durationMinutes: durationMinutes, isLocked: isLocked, attendeeCount: attendeeCount, imageURL: imageURL, category: category)
    }
}
