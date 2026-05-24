import Foundation

@Observable
final class HomeViewModel {
    private(set) var posts: [Post] = []
    private(set) var featuredEvents: [Event] = []
    private(set) var bartenders: [Bartender] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let fetchPostsUseCase: FetchPostsUseCase
    private let fetchEventsUseCase: FetchEventsUseCase
    private let fetchBartendersUseCase: FetchBartendersUseCase
    private let toggleLikeUseCase: TogglePostLikeUseCase

    init(
        fetchPostsUseCase: FetchPostsUseCase,
        fetchEventsUseCase: FetchEventsUseCase,
        fetchBartendersUseCase: FetchBartendersUseCase,
        toggleLikeUseCase: TogglePostLikeUseCase
    ) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.fetchEventsUseCase = fetchEventsUseCase
        self.fetchBartendersUseCase = fetchBartendersUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
    }

    func loadFeed() async {
        isLoading = true
        errorMessage = nil
        do {
            async let posts = fetchPostsUseCase.execute()
            async let events = fetchEventsUseCase.executeFeatured()
            async let bartenders = fetchBartendersUseCase.execute()
            (self.posts, self.featuredEvents, self.bartenders) = try await (posts, events, bartenders)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func toggleLike(postId: String) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        do {
            let updated = try await toggleLikeUseCase.execute(postId: postId)
            posts[index] = updated
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
