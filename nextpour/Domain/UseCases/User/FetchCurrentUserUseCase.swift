import Foundation

final class FetchCurrentUserUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> User {
        try await repository.fetchCurrentUser()
    }
}
