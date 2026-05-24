import SwiftUI

struct AuraTierProgressBar: View {
    let points: Int
    let tier: RewardTier

    var body: some View {
        VStack(spacing: UNPSpacing.xs) {
            ProgressView(value: progress)
                .tint(tier.color)
                .scaleEffect(x: 1, y: 1.4)
            HStack {
                Text(tier.displayName)
                    .font(UNPFontStyle.label(10))
                    .foregroundStyle(tier.color)
                Spacer()
                Text(trailingLabel)
                    .font(UNPFontStyle.label(10))
                    .foregroundStyle(tier == .gold ? UNPColor.gold : UNPColor.textMuted)
            }
        }
    }

    private var progress: Double {
        switch tier {
        case .bronze:
            return min(1.0, Double(points) / Double(RewardTier.silver.minimumPoints))
        case .silver:
            let base = RewardTier.silver.minimumPoints
            let next = RewardTier.gold.minimumPoints
            return min(1.0, Double(points - base) / Double(next - base))
        case .gold:
            return 1.0
        }
    }

    private var trailingLabel: String {
        switch tier {
        case .bronze: return "\(max(0, RewardTier.silver.minimumPoints - points)) pts to Silver"
        case .silver: return "\(max(0, RewardTier.gold.minimumPoints - points)) pts to Gold"
        case .gold:   return "Max Tier ✦"
        }
    }
}
