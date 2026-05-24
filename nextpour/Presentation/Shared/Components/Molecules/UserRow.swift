import SwiftUI

struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            AvatarView(name: user.name, imageURL: user.avatarURL, size: 44)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(user.name)
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(UNPColor.textPrimary)
                    if user.isAmbassador {
                        TagBadge(text: "Ambassador", color: UNPColor.gold, size: 10)
                    }
                }
                Text(user.role.rawValue.capitalized)
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textSecondary)
            }
            Spacer()
            tierBadge
        }
    }

    private var tierBadge: some View {
        let color: Color
        switch user.rewardTier {
        case .bronze: color = UNPColor.bronze
        case .silver: color = UNPColor.silver
        case .gold: color = UNPColor.gold
        }
        return TagBadge(text: user.rewardTier.displayName, color: color, size: 11)
    }
}
