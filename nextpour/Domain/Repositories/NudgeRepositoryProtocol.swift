import Foundation

protocol NudgeRepositoryProtocol {
    func fetchActive() async throws -> [Nudge]
    func vote(nudgeId: String, optionId: String) async throws -> Nudge
}
