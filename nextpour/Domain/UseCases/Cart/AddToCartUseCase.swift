import Foundation

final class AddToCartUseCase {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute(item: CartItem) async throws -> [CartItem] {
        try await repository.addItem(item)
    }
}
