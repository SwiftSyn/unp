import Foundation

final class VenueRepositoryImpl: VenueRepositoryProtocol {
    private let localDataSource: VenueLocalDataSource

    init(localDataSource: VenueLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [Venue] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }

    func fetchNearby() async throws -> [Venue] {
        try await fetchAll().sorted { $0.distanceMiles < $1.distanceMiles }
    }
}
