import Foundation

struct Venue: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let imageURL: String?
    let rating: Double
    let category: String
    let distanceMiles: Double
    let isOpen: Bool
}
