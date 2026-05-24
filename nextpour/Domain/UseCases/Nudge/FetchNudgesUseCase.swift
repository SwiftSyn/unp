import Foundation

final class FetchNudgesUseCase {
    private let repository: NudgeRepositoryProtocol

    init(repository: NudgeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Nudge] {
        try await repository.fetchActive()
    }
}
