import Foundation

protocol EventRepositoryProtocol {
    func fetchAll() async throws -> [Event]
    func fetchFeatured() async throws -> [Event]
    func fetchByCategory(_ category: EventCategory) async throws -> [Event]
}
