import SwiftUI

extension RewardTier {
    var color: Color {
        switch self {
        case .bronze: return UNPColor.bronze
        case .silver: return UNPColor.silver
        case .gold:   return UNPColor.gold
        }
    }

    var icon: String {
        self == .gold ? "star.fill" : "medal.fill"
    }
}
