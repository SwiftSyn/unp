import Foundation

@Observable
final class CartViewModel {
    private(set) var items: [CartItem] = []
    private(set) var isLoading = false
    private(set) var isPlacingOrder = false
    private(set) var orderPlaced = false
    private(set) var errorMessage: String?

    private let fetchCartUseCase: FetchCartUseCase
    private let cartRepository: CartRepositoryProtocol
    private let placeOrderUseCase: PlaceOrderUseCase

    var total: Double { items.reduce(0) { $0 + $1.subtotal } }
    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }

    init(fetchCartUseCase: FetchCartUseCase, cartRepository: CartRepositoryProtocol, placeOrderUseCase: PlaceOrderUseCase) {
        self.fetchCartUseCase = fetchCartUseCase
        self.cartRepository = cartRepository
        self.placeOrderUseCase = placeOrderUseCase
    }

    func loadCart() async {
        isLoading = true
        defer { isLoading = false }
        do { items = try await fetchCartUseCase.execute() } catch { errorMessage = error.localizedDescription }
    }

    func removeItem(_ item: CartItem) async {
        do { items = try await cartRepository.removeItem(id: item.id) } catch { errorMessage = error.localizedDescription }
    }

    func updateQuantity(id: String, quantity: Int) async {
        do { items = try await cartRepository.updateQuantity(id: id, quantity: quantity) } catch { errorMessage = error.localizedDescription }
    }

    func placeOrder() async {
        isPlacingOrder = true
        defer { isPlacingOrder = false }
        do {
            _ = try await placeOrderUseCase.execute(items: items, deliveryAddress: "Detroit, MI")
            items = []
            orderPlaced = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
