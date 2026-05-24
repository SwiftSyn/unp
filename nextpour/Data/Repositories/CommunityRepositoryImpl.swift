import Foundation

final class CommunityRepositoryImpl: CommunityRepositoryProtocol {
    private let localDataSource: CommunityLocalDataSource

    init(localDataSource: CommunityLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchMessages() async throws -> [CommunityMessage] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }

    func fetchMessages(forEventId eventId: String) async throws -> [CommunityMessage] {
        try await fetchMessages().filter { $0.eventId == eventId }
    }
}
