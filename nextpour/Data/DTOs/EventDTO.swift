import Foundation

struct EventDTO: Codable {
    let id: String
    let title: String
    let description: String
    let venueName: String
    let venueAddress: String
    let date: String
    let imageURL: String?
    let category: String
    let attendeeCount: Int
    let isFeatured: Bool

    func toDomain() -> Event {
        Event(
            id: id,
            title: title,
            description: description,
            venueName: venueName,
            venueAddress: venueAddress,
            date: ISO8601DateFormatter().date(from: date) ?? Date(),
            imageURL: imageURL,
            category: EventCategory(rawValue: category) ?? .social,
            attendeeCount: attendeeCount,
            isFeatured: isFeatured
        )
    }
}
