import Foundation

final class BartenderClassRepositoryImpl: BartenderClassRepositoryProtocol {
    private let localDataSource: BartenderClassLocalDataSource

    init(localDataSource: BartenderClassLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [BartenderClass] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }
}
