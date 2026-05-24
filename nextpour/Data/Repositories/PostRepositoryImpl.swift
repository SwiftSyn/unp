import Foundation

final class PostRepositoryImpl: PostRepositoryProtocol {
    private let localDataSource: PostLocalDataSource
    private let cache = DataCache.shared
    private let cacheKey = "posts"
    private var likedPostIds: Set<String> = []

    init(localDataSource: PostLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchFeed() async throws -> [Post] {
        let dtos: [PostDTO]
        do {
            dtos = try localDataSource.fetchAll()
            cache.save(dtos, key: cacheKey)
        } catch {
            guard let cached = cache.load([PostDTO].self, key: cacheKey) else { throw error }
            dtos = cached
        }
        return dtos.map { dto in
            var post = dto.toDomain()
            if likedPostIds.contains(post.id) {
                post.isLiked = true
                post.likeCount += 1
            }
            return post
        }
    }

    func toggleLike(postId: String) async throws -> Post {
        var posts = try await fetchFeed()
        guard let index = posts.firstIndex(where: { $0.id == postId }) else {
            throw APIError.noData
        }
        if likedPostIds.contains(postId) {
            likedPostIds.remove(postId)
            posts[index].isLiked = false
            posts[index].likeCount -= 1
        } else {
            likedPostIds.insert(postId)
            posts[index].isLiked = true
            posts[index].likeCount += 1
        }
        return posts[index]
    }
}
