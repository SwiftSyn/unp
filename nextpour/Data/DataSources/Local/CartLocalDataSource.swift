import Foundation

final class CartLocalDataSource {
    private let key = "nextpour_cart"

    func fetchCart() -> [CartItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([CartItem].self, from: data) else {
            return []
        }
        return items
    }

    func saveCart(_ items: [CartItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
