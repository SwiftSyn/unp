import Foundation

protocol BeverageRepositoryProtocol {
    func fetchAll() async throws -> [Beverage]
    func fetchByCategory(_ category: BeverageCategory) async throws -> [Beverage]
    func fetchById(_ id: String) async throws -> Beverage?
}
