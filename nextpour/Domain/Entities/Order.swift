import Foundation

enum OrderStatus: String, Codable {
    case pending, confirmed, preparing, ready, delivered

    var displayName: String { rawValue.capitalized }
}

struct CartItem: Identifiable, Equatable, Codable {
    let id: String
    let beverageId: String
    let name: String
    let price: Double
    var quantity: Int

    var subtotal: Double { price * Double(quantity) }
}

struct Order: Identifiable, Equatable {
    let id: String
    let items: [CartItem]
    let status: OrderStatus
    let subtotal: Double
    let total: Double
    let timestamp: Date
    let deliveryAddress: String
}
