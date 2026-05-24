import Foundation

final class VoteNudgeUseCase {
    private let repository: NudgeRepositoryProtocol

    init(repository: NudgeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nudgeId: String, optionId: String) async throws -> Nudge {
        try await repository.vote(nudgeId: nudgeId, optionId: optionId)
    }
}
