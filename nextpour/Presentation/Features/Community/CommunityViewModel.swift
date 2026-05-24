import Foundation

@Observable
final class CommunityViewModel {
    private(set) var messages: [CommunityMessage] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let fetchMessagesUseCase: FetchCommunityMessagesUseCase

    init(fetchMessagesUseCase: FetchCommunityMessagesUseCase) {
        self.fetchMessagesUseCase = fetchMessagesUseCase
    }

    func loadMessages() async {
        isLoading = true
        defer { isLoading = false }
        do { messages = try await fetchMessagesUseCase.execute() } catch { errorMessage = error.localizedDescription }
    }
}
