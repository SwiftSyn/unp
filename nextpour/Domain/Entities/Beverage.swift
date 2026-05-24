import Foundation

enum BeverageCategory: String, Codable, CaseIterable {
    case classics, tropical, mocktails, spirits, wine, seasonal

    var displayName: String {
        switch self {
        case .classics: return "Classics"
        case .tropical: return "Tropical"
        case .mocktails: return "Mocktails"
        case .spirits: return "Spirits"
        case .wine: return "Wine"
        case .seasonal: return "Seasonal"
        }
    }
}

struct Beverage: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let imageURL: String?
    let ingredients: [String]
    let steps: [String]
    let category: BeverageCategory
    let rating: Double
    let isAmbassadorUpload: Bool
    let authorId: String?
}
