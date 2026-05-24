import Foundation

struct VenueDTO: Codable {
    let id: String
    let name: String
    let address: String
    let imageURL: String?
    let rating: Double
    let category: String
    let distanceMiles: Double
    let isOpen: Bool

    func toDomain() -> Venue {
        Venue(id: id, name: name, address: address, imageURL: imageURL, rating: rating, category: category, distanceMiles: distanceMiles, isOpen: isOpen)
    }
}
