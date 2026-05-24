import Foundation

struct NudgeOptionDTO: Codable {
    let id: String
    let text: String
    let voteCount: Int

    func toDomain() -> NudgeOption {
        NudgeOption(id: id, text: text, voteCount: voteCount)
    }
}

struct NudgeDTO: Codable {
    let id: String
    let question: String
    let options: [NudgeOptionDTO]
    let expiresAt: String

    func toDomain() -> Nudge {
        Nudge(
            id: id,
            question: question,
            options: options.map { $0.toDomain() },
            expiresAt: ISO8601DateFormatter().date(from: expiresAt) ?? Date()
        )
    }
}
