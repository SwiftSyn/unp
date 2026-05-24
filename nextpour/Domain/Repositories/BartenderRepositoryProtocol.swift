import Foundation

protocol BartenderRepositoryProtocol {
    func fetchAll() async throws -> [Bartender]
    func fetchVerified() async throws -> [Bartender]
}
