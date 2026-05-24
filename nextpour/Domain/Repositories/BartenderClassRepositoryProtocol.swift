import Foundation

protocol BartenderClassRepositoryProtocol {
    func fetchAll() async throws -> [BartenderClass]
}
