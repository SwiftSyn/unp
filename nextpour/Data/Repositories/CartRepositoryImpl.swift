import Foundation

final class CartRepositoryImpl: CartRepositoryProtocol {
    private let localDataSource = CartLocalDataSource()

    func fetchCart() async throws -> [CartItem] {
        localDataSource.fetchCart()
    }

    func addItem(_ item: CartItem) async throws -> [CartItem] {
        var items = localDataSource.fetchCart()
        if let index = items.firstIndex(where: { $0.beverageId == item.beverageId }) {
            items[index].quantity += item.quantity
        } else {
            items.append(item)
        }
        localDataSource.saveCart(items)
        return items
    }

    func removeItem(id: String) async throws -> [CartItem] {
        var items = localDataSource.fetchCart()
        items.removeAll { $0.id == id }
        localDataSource.saveCart(items)
        return items
    }

    func updateQuantity(id: String, quantity: Int) async throws -> [CartItem] {
        var items = localDataSource.fetchCart()
        if let index = items.firstIndex(where: { $0.id == id }) {
            if quantity <= 0 { items.remove(at: index) } else { items[index].quantity = quantity }
        }
        localDataSource.saveCart(items)
        return items
    }

    func clearCart() async throws {
        localDataSource.saveCart([])
    }
}
