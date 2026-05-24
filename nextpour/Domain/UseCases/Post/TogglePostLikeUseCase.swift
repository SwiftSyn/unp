import Foundation

final class TogglePostLikeUseCase {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: String) async throws -> Post {
        try await repository.toggleLike(postId: postId)
    }
}
