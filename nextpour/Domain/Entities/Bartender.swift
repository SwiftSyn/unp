import Foundation

struct Bartender: Identifiable, Equatable {
    let id: String
    let name: String
    let specialties: [String]
    let rating: Double
    let imageURL: String?
    let isVerified: Bool
    let bio: String
    let yearsExperience: Int
}
