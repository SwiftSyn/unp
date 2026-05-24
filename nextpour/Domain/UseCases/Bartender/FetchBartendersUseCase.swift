import Foundation

final class FetchBartendersUseCase {
    private let repository: BartenderRepositoryProtocol

    init(repository: BartenderRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Bartender] {
        try await repository.fetchAll()
    }
}
