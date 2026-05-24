import Foundation

struct NudgeOption: Identifiable, Equatable {
    let id: String
    let text: String
    var voteCount: Int
}

struct Nudge: Identifiable, Equatable {
    let id: String
    let question: String
    var options: [NudgeOption]
    let expiresAt: Date
}
