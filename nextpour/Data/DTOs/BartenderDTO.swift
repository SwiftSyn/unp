import Foundation

struct BartenderDTO: Codable {
    let id: String
    let name: String
    let specialties: [String]
    let rating: Double
    let imageURL: String?
    let isVerified: Bool
    let bio: String
    let yearsExperience: Int

    func toDomain() -> Bartender {
        Bartender(id: id, name: name, specialties: specialties, rating: rating, imageURL: imageURL, isVerified: isVerified, bio: bio, yearsExperience: yearsExperience)
    }
}
