import Foundation

final class NudgeRepositoryImpl: NudgeRepositoryProtocol {
    private let localDataSource: NudgeLocalDataSource
    private var nudges: [Nudge] = []

    init(localDataSource: NudgeLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchActive() async throws -> [Nudge] {
        nudges = try localDataSource.fetchAll().map { $0.toDomain() }
        return nudges.filter { $0.expiresAt > Date() }
    }

    func vote(nudgeId: String, optionId: String) async throws -> Nudge {
        guard let nudgeIndex = nudges.firstIndex(where: { $0.id == nudgeId }),
              let optionIndex = nudges[nudgeIndex].options.firstIndex(where: { $0.id == optionId }) else {
            throw APIError.noData
        }
        nudges[nudgeIndex].options[optionIndex].voteCount += 1
        return nudges[nudgeIndex]
    }
}
