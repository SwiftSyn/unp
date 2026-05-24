import Foundation

protocol UserRepositoryProtocol {
    func fetchCurrentUser() async throws -> User
    func fetchUser(id: String) async throws -> User?
    func fetchAll() async throws -> [User]
}
