import Foundation

enum RewardCatalogHostType: String, Codable, CaseIterable {
    case venue
    case eventHost

    var displayName: String {
        switch self {
        case .venue: return "Venue"
        case .eventHost: return "Event Host"
        }
    }

    var systemIcon: String {
        switch self {
        case .venue: return "building.2.fill"
        case .eventHost: return "person.badge.star.fill"
        }
    }
}

struct RewardCatalogItem: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let pointsCost: Int
    let hostName: String
    let hostType: RewardCatalogHostType
    let category: String
}
