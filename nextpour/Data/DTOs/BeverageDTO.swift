import Foundation

struct BeverageDTO: Codable {
    let id: String
    let name: String
    let description: String
    let imageURL: String?
    let ingredients: [String]
    let steps: [String]
    let category: String
    let rating: Double
    let isAmbassadorUpload: Bool
    let authorId: String?

    func toDomain() -> Beverage {
        Beverage(
            id: id,
            name: name,
            description: description,
            imageURL: imageURL,
            ingredients: ingredients,
            steps: steps,
            category: BeverageCategory(rawValue: category) ?? .classics,
            rating: rating,
            isAmbassadorUpload: isAmbassadorUpload,
            authorId: authorId
        )
    }
}
