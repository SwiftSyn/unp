import Foundation

final class UserRepositoryImpl: UserRepositoryProtocol {
    private let localDataSource: UserLocalDataSource

    init(localDataSource: UserLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchCurrentUser() async throws -> User {
        guard let first = try localDataSource.fetchAll().first else {
            throw APIError.noData
        }
        return first.toDomain()
    }

    func fetchUser(id: String) async throws -> User? {
        try localDataSource.fetchAll().first { $0.id == id }?.toDomain()
    }

    func fetchAll() async throws -> [User] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }
}
