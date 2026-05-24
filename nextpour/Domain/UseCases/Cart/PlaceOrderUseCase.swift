import Foundation

final class PlaceOrderUseCase {
    private let orderRepository: OrderRepositoryProtocol
    private let cartRepository: CartRepositoryProtocol

    init(orderRepository: OrderRepositoryProtocol, cartRepository: CartRepositoryProtocol) {
        self.orderRepository = orderRepository
        self.cartRepository = cartRepository
    }

    func execute(items: [CartItem], deliveryAddress: String) async throws -> Order {
        let order = try await orderRepository.placeOrder(items: items, deliveryAddress: deliveryAddress)
        try await cartRepository.clearCart()
        return order
    }
}
