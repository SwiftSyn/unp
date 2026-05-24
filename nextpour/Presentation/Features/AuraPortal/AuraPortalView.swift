import SwiftUI

struct AuraPortalView: View {
    @State private var viewModel: AuraPortalViewModel
    @Environment(AppTheme.self) private var theme
    @Environment(\.dismiss) private var dismiss

    init(reward: Reward?) {
        let di = DIContainer.shared
        _viewModel = State(initialValue: AuraPortalViewModel(
            fetchCatalogUseCase: di.makeFetchRewardCatalogUseCase(),
            reward: reward
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                theme.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: UNPSpacing.lg) {
                        balanceHeader
                        phase2Banner
                        filterRow
                        catalogContent
                    }
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.xxl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { portalToolbar }
            .task { await viewModel.load() }
        }
    }

    // MARK: - Toolbar
    private var portalToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(UNPColor.ember)
                    Text("Aura Portal")
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

    // MARK: - Balance header
    private var balanceHeader: some View {
        ZStack {
            RoundedRectangle(cornerRadius: UNPRadius.large)
                .fill(UNPColor.midnight)
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.large)
                        .stroke(UNPColor.ember.opacity(0.25), lineWidth: 1)
                )
            UNPColor.ember.opacity(0.06)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))

            VStack(spacing: UNPSpacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                        Text("Your Aura Balance")
                            .font(UNPFontStyle.label())
                            .foregroundStyle(UNPColor.textMuted)
                            .textCase(.uppercase)
                            .tracking(0.8)
                        HStack(alignment: .firstTextBaseline, spacing: UNPSpacing.xs) {
                            Text("✦")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(UNPColor.ember)
                            Text("\(viewModel.userPoints)")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(UNPColor.textPrimary)
                            Text("pts")
                                .font(UNPFontStyle.body())
                                .foregroundStyle(UNPColor.textMuted)
                                .padding(.bottom, 4)
                        }
                    }
                    Spacer()
                    tierBadge(viewModel.userTier)
                }
                AuraTierProgressBar(points: viewModel.userPoints, tier: viewModel.userTier)
            }
            .padding(UNPSpacing.md)
        }
        .padding(.top, UNPSpacing.sm)
    }

    private func tierBadge(_ tier: RewardTier) -> some View {
        VStack(spacing: UNPSpacing.xs) {
            Image(systemName: tier.icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(tier.color)
            Text(tier.displayName)
                .font(UNPFontStyle.label())
                .foregroundStyle(tier.color)
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
        .background(tier.color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
    }

    // MARK: - Phase 2 banner
    private var phase2Banner: some View {
        HStack(spacing: UNPSpacing.sm) {
            Image(systemName: "lock.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(UNPColor.neon)
            VStack(alignment: .leading, spacing: 2) {
                Text("Redemption unlocks in Phase 2")
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Browse rewards now — redeem when the backend goes live.")
                    .font(UNPFontStyle.label(11))
                    .foregroundStyle(UNPColor.textMuted)
            }
            Spacer()
        }
        .padding(UNPSpacing.md)
        .background(UNPColor.neon.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: UNPRadius.medium)
                .stroke(UNPColor.neon.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
    }

    // MARK: - Filters
    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ToggleChipGroup(
                options: AuraFilter.allCases,
                selection: Bindable(viewModel).selectedFilter,
                label: { $0.rawValue },
                accentColor: UNPColor.ember
            )
        }
    }

    // MARK: - Catalog
    @ViewBuilder
    private var catalogContent: some View {
        if viewModel.isLoading {
            skeletonCatalog
        } else if let error = viewModel.errorMessage {
            ErrorStateView(message: error) {
                Task { await viewModel.load() }
            }
        } else if viewModel.filteredItems.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: UNPSpacing.sm) {
                ForEach(viewModel.filteredItems) { item in
                    RewardCatalogCard(item: item, canAfford: viewModel.canAfford(item))
                }
            }
        }
    }

    private var skeletonCatalog: some View {
        VStack(spacing: UNPSpacing.sm) {
            ForEach(0..<5, id: \.self) { _ in SkeletonRowView() }
        }
    }

    private var emptyState: some View {
        VStack(spacing: UNPSpacing.lg) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(UNPColor.ember.opacity(0.4))
            VStack(spacing: UNPSpacing.xs) {
                Text("No rewards in this category yet")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Check back when Phase 2 launches for more.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(UNPSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Catalog card
struct RewardCatalogCard: View {
    let item: RewardCatalogItem
    let canAfford: Bool

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            IconBadge(
                systemName: item.hostType.systemIcon,
                color: hostColor,
                size: 52,
                backgroundColor: hostColor.opacity(0.12)
            )

            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                HStack(spacing: UNPSpacing.xs) {
                    Text(item.title)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    pointsBadge
                }
                Text(item.description)
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(2)
                HStack(spacing: UNPSpacing.xs) {
                    TagBadge(text: item.hostType.displayName, color: hostColor, size: 10)
                    Text(item.hostName)
                        .font(UNPFontStyle.label(10))
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
        .overlay(
            RoundedRectangle(cornerRadius: UNPRadius.large)
                .stroke(canAfford ? UNPColor.ember.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }

    private var pointsBadge: some View {
        HStack(spacing: 3) {
            Text("✦").font(.system(size: 9, weight: .bold))
            Text("\(item.pointsCost)").font(UNPFontStyle.label())
        }
        .foregroundStyle(canAfford ? UNPColor.ember : UNPColor.textMuted)
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, 3)
        .background(canAfford ? UNPColor.ember.opacity(0.12) : UNPColor.surfaceElevated)
        .clipShape(Capsule())
    }

    private var hostColor: Color {
        item.hostType == .venue ? UNPColor.azure : UNPColor.neon
    }
}
