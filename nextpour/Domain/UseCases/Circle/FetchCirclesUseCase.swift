import Foundation

final class FetchCirclesUseCase {
    private let repository: PourCircleRepositoryProtocol

    init(repository: PourCircleRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [PourCircle] {
        try await repository.fetchAll()
    }
}
