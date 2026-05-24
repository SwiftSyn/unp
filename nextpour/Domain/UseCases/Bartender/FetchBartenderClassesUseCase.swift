import Foundation

final class FetchBartenderClassesUseCase {
    private let repository: BartenderClassRepositoryProtocol

    init(repository: BartenderClassRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [BartenderClass] {
        try await repository.fetchAll()
    }
}
