import Foundation

final class BeverageRepositoryImpl: BeverageRepositoryProtocol {
    private let localDataSource: BeverageLocalDataSource
    private let cache = DataCache.shared
    private let cacheKey = "beverages"

    init(localDataSource: BeverageLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [Beverage] {
        do {
            let dtos = try localDataSource.fetchAll()
            cache.save(dtos, key: cacheKey)
            return dtos.map { $0.toDomain() }
        } catch {
            if let cached = cache.load([BeverageDTO].self, key: cacheKey) {
                return cached.map { $0.toDomain() }
            }
            throw error
        }
    }

    func fetchByCategory(_ category: BeverageCategory) async throws -> [Beverage] {
        try await fetchAll().filter { $0.category == category }
    }

    func fetchById(_ id: String) async throws -> Beverage? {
        try await fetchAll().first { $0.id == id }
    }
}
