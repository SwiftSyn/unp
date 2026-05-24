import Foundation

protocol OrderRepositoryProtocol {
    func placeOrder(items: [CartItem], deliveryAddress: String) async throws -> Order
    func fetchOrders() async throws -> [Order]
}
