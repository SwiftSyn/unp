import Foundation

final class BartenderRepositoryImpl: BartenderRepositoryProtocol {
    private let localDataSource: BartenderLocalDataSource

    init(localDataSource: BartenderLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [Bartender] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }

    func fetchVerified() async throws -> [Bartender] {
        try await fetchAll().filter { $0.isVerified }
    }
}
