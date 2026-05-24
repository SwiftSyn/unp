import Foundation

final class FetchBeveragesUseCase {
    private let repository: BeverageRepositoryProtocol

    init(repository: BeverageRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Beverage] {
        try await repository.fetchAll()
    }

    func execute(category: BeverageCategory) async throws -> [Beverage] {
        try await repository.fetchByCategory(category)
    }
}
