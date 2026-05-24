import Foundation

final class FetchCommunityMessagesUseCase {
    private let repository: CommunityRepositoryProtocol

    init(repository: CommunityRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [CommunityMessage] {
        try await repository.fetchMessages()
    }

    func execute(forEventId eventId: String) async throws -> [CommunityMessage] {
        try await repository.fetchMessages(forEventId: eventId)
    }
}
