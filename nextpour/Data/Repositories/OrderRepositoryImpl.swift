import Foundation

final class OrderRepositoryImpl: OrderRepositoryProtocol {
    private var orders: [Order] = []

    func placeOrder(items: [CartItem], deliveryAddress: String) async throws -> Order {
        let subtotal = items.reduce(0) { $0 + $1.subtotal }
        let order = Order(
            id: UUID().uuidString,
            items: items,
            status: .confirmed,
            subtotal: subtotal,
            total: subtotal * 1.08,
            timestamp: Date(),
            deliveryAddress: deliveryAddress
        )
        orders.append(order)
        return order
    }

    func fetchOrders() async throws -> [Order] { orders }
}
