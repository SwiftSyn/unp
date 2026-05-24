import SwiftUI

struct AuraTierDetailView: View {
    let reward: Reward
    @Environment(AppTheme.self) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: UNPSpacing.lg) {
                        heroSection
                        tierPathSection
                        howToEarnSection
                    }
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.xxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { tierToolbar }
        }
    }

    // MARK: - Toolbar
    private var tierToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: reward.tier.icon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(reward.tier.color)
                    Text("Tier Status")
                        .font(UNPFontStyle.heading())
                        .foregroundStyle(UNPColor.textPrimary)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(UNPColor.textSecondary)
                }
            }
        }
    }

    // MARK: - Hero
    private var heroSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: UNPRadius.large)
                .fill(UNPColor.midnight)
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.large)
                        .stroke(reward.tier.color.opacity(0.35), lineWidth: 1)
                )
            reward.tier.color.opacity(0.05)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))

            VStack(spacing: UNPSpacing.md) {
                ZStack {
                    Circle()
                        .fill(reward.tier.color.opacity(0.12))
                        .frame(width: 80, height: 80)
                    Image(systemName: reward.tier.icon)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(reward.tier.color)
                }
                .shadow(color: reward.tier.color.opacity(0.4), radius: 18, x: 0, y: 0)

                VStack(spacing: UNPSpacing.xs) {
                    Text(reward.tier.displayName)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(reward.tier.color)
                    Text("Current Tier")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                        .textCase(.uppercase)
                        .tracking(0.8)
                }

                HStack(spacing: UNPSpacing.xl) {
                    statCell(value: "\(reward.points)", label: "Total Pts")
                    Rectangle().fill(UNPColor.surfaceElevated).frame(width: 1, height: 32)
                    statCell(value: nextTierName, label: "Next Tier")
                    Rectangle().fill(UNPColor.surfaceElevated).frame(width: 1, height: 32)
                    statCell(value: ptsNeeded, label: "Pts Needed")
                }

                AuraTierProgressBar(points: reward.points, tier: reward.tier)
            }
            .padding(UNPSpacing.lg)
        }
        .padding(.top, UNPSpacing.sm)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(UNPColor.textPrimary)
            Text(label)
                .font(UNPFontStyle.label(10))
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.4)
        }
    }

    // MARK: - Tier path
    private var tierPathSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("Tier Path")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.8)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                tierRow(.bronze, unlocked: true)
                tierConnector
                tierRow(.silver, unlocked: reward.tier == .silver || reward.tier == .gold)
                tierConnector
                tierRow(.gold,   unlocked: reward.tier == .gold)
            }
            .unpCard()
        }
    }

    private func tierRow(_ tier: RewardTier, unlocked: Bool) -> some View {
        let isCurrent = tier == reward.tier
        return HStack(spacing: UNPSpacing.md) {
            ZStack {
                Circle()
                    .fill(unlocked ? tier.color.opacity(0.15) : UNPColor.surfaceElevated)
                    .frame(width: 40, height: 40)
                Image(systemName: tier.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(unlocked ? tier.color : UNPColor.textMuted)
            }
            .shadow(color: isCurrent ? tier.color.opacity(0.35) : .clear, radius: 10, x: 0, y: 0)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: UNPSpacing.xs) {
                    Text(tier.displayName)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(unlocked ? UNPColor.textPrimary : UNPColor.textMuted)
                    if isCurrent {
                        TagBadge(text: "Current", color: tier.color, size: 10)
                    }
                }
                Text(requirementText(tier))
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
            }

            Spacer()

            Image(systemName: unlocked ? (isCurrent ? "checkmark.circle.fill" : "checkmark.circle") : "lock.fill")
                .font(.system(size: isCurrent ? 18 : 14))
                .foregroundStyle(unlocked ? tier.color : UNPColor.textMuted)
        }
        .padding(UNPSpacing.md)
        .background(isCurrent ? tier.color.opacity(0.06) : Color.clear)
    }

    private var tierConnector: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: UNPSpacing.md + 20)
            Rectangle()
                .fill(UNPColor.surfaceElevated)
                .frame(width: 2, height: 16)
            Spacer()
        }
    }

    // MARK: - How to earn
    private var howToEarnSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("How to Earn Aura")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.8)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(earnActions.enumerated()), id: \.offset) { index, action in
                    earnRow(action)
                    if index < earnActions.count - 1 {
                        Divider()
                            .background(UNPColor.surfaceElevated)
                            .padding(.leading, UNPSpacing.lg + 26)
                    }
                }
            }
            .unpCard()
        }
    }

    private func earnRow(_ action: EarnAction) -> some View {
        HStack(spacing: UNPSpacing.md) {
            IconBadge(
                systemName: action.icon,
                color: action.color,
                size: 34,
                backgroundColor: action.color.opacity(0.12)
            )
            Text(action.label)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
            Spacer()
            LabelChip(text: action.pts, color: UNPColor.azure)
        }
        .padding(UNPSpacing.md)
    }

    // MARK: - Helpers
    private var nextTierName: String {
        switch reward.tier {
        case .bronze: return "Silver"
        case .silver: return "Gold"
        case .gold:   return "Max"
        }
    }

    private var ptsNeeded: String {
        switch reward.tier {
        case .bronze: return "\(max(0, RewardTier.silver.minimumPoints - reward.points))"
        case .silver: return "\(max(0, RewardTier.gold.minimumPoints - reward.points))"
        case .gold:   return "—"
        }
    }

    private func requirementText(_ tier: RewardTier) -> String {
        switch tier {
        case .bronze: return "Starting tier — 0 pts"
        case .silver: return "Requires \(RewardTier.silver.minimumPoints) pts"
        case .gold:   return "Requires \(RewardTier.gold.minimumPoints) pts"
        }
    }

    // MARK: - Data
    private struct EarnAction {
        let icon: String
        let label: String
        let pts: String
        let color: Color
    }

    private var earnActions: [EarnAction] {
        [
            EarnAction(icon: "building.2.fill",         label: "Visit a participating venue",  pts: "+50 pts",  color: UNPColor.azure),
            EarnAction(icon: "calendar.badge.checkmark", label: "Attend an event",              pts: "+100 pts", color: UNPColor.ember),
            EarnAction(icon: "bookmark.fill",            label: "Save a recipe",                pts: "+25 pts",  color: UNPColor.neon),
            EarnAction(icon: "square.and.arrow.up",      label: "Share an event",               pts: "+15 pts",  color: UNPColor.copper),
            EarnAction(icon: "person.3.fill",            label: "Join a Pour Circle",            pts: "+30 pts",  color: UNPColor.azure),
            EarnAction(icon: "checkmark.seal.fill",      label: "Complete a journey",            pts: "+50 pts",  color: UNPColor.ember),
            EarnAction(icon: "star.bubble.fill",         label: "Leave a venue review",          pts: "+20 pts",  color: UNPColor.neon),
            EarnAction(icon: "person.badge.plus",        label: "Refer a friend",               pts: "+75 pts",  color: UNPColor.gold),
        ]
    }
}
