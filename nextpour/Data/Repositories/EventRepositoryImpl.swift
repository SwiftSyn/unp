import Foundation

final class EventRepositoryImpl: EventRepositoryProtocol {
    private let localDataSource: EventLocalDataSource
    private let cache = DataCache.shared
    private let cacheKey = "events"

    init(localDataSource: EventLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [Event] {
        do {
            let dtos = try localDataSource.fetchAll()
            cache.save(dtos, key: cacheKey)
            return dtos.map { $0.toDomain() }
        } catch {
            if let cached = cache.load([EventDTO].self, key: cacheKey) {
                return cached.map { $0.toDomain() }
            }
            throw error
        }
    }

    func fetchFeatured() async throws -> [Event] {
        try await fetchAll().filter { $0.isFeatured }
    }

    func fetchByCategory(_ category: EventCategory) async throws -> [Event] {
        try await fetchAll().filter { $0.category == category }
    }
}
