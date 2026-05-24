import Foundation

protocol PostRepositoryProtocol {
    func fetchFeed() async throws -> [Post]
    func toggleLike(postId: String) async throws -> Post
}
