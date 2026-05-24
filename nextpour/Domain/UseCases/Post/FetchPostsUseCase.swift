import Foundation

final class FetchPostsUseCase {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Post] {
        try await repository.fetchFeed()
    }
}
