import Foundation

protocol CommunityRepositoryProtocol {
    func fetchMessages() async throws -> [CommunityMessage]
    func fetchMessages(forEventId eventId: String) async throws -> [CommunityMessage]
}
