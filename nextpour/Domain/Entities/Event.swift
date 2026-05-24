import Foundation

enum EventCategory: String, Codable, CaseIterable {
    case masterclass, tasting, social, festival, brunch, live_music

    var displayName: String {
        switch self {
        case .masterclass: return "Masterclass"
        case .tasting: return "Tasting"
        case .social: return "Social"
        case .festival: return "Festival"
        case .brunch: return "Brunch"
        case .live_music: return "Live Music"
        }
    }
}

struct Event: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let venueName: String
    let venueAddress: String
    let date: Date
    let imageURL: String?
    let category: EventCategory
    let attendeeCount: Int
    let isFeatured: Bool
}
