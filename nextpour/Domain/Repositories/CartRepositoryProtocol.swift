import Foundation

protocol CartRepositoryProtocol {
    func fetchCart() async throws -> [CartItem]
    func addItem(_ item: CartItem) async throws -> [CartItem]
    func removeItem(id: String) async throws -> [CartItem]
    func updateQuantity(id: String, quantity: Int) async throws -> [CartItem]
    func clearCart() async throws
}
