import Foundation

protocol VenueRepositoryProtocol {
    func fetchAll() async throws -> [Venue]
    func fetchNearby() async throws -> [Venue]
}
