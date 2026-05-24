import Foundation

protocol PourCircleRepositoryProtocol {
    func fetchAll() async throws -> [PourCircle]
    func fetchJoined() async throws -> [PourCircle]
    func toggleMembership(circleId: String) async throws -> PourCircle
}
