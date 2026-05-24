import Foundation

final class FetchCartUseCase {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [CartItem] {
        try await repository.fetchCart()
    }
}
