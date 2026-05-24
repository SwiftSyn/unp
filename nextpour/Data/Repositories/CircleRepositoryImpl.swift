import Foundation

final class PourCircleRepositoryImpl: PourCircleRepositoryProtocol {
    private let localDataSource: CircleLocalDataSource
    private var memberPourCircleIds: Set<String> = []

    init(localDataSource: CircleLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAll() async throws -> [PourCircle] {
        try localDataSource.fetchAll().map { dto in
            var circle = dto.toDomain()
            if memberPourCircleIds.contains(circle.id) { circle.isMember = true }
            return circle
        }
    }

    func fetchJoined() async throws -> [PourCircle] {
        try await fetchAll().filter { $0.isMember }
    }

    func toggleMembership(circleId: String) async throws -> PourCircle {
        var circles = try await fetchAll()
        guard let index = circles.firstIndex(where: { $0.id == circleId }) else {
            throw APIError.noData
        }
        if memberPourCircleIds.contains(circleId) {
            memberPourCircleIds.remove(circleId)
            circles[index].isMember = false
        } else {
            memberPourCircleIds.insert(circleId)
            circles[index].isMember = true
        }
        return circles[index]
    }
}
