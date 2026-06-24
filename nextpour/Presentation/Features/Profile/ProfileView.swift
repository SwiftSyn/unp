import SwiftUI

// MARK: - Glow effect modifier for tappable Aura zones
private struct AuraGlowModifier: ViewModifier {
    let color: Color
    @State private var pulse = false

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(pulse ? 0.28 : 0.08), radius: pulse ? 10 : 4, x: 0, y: 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
    }
}

// MARK: - Press-scale button style for tappable zones
private struct AuraZoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    fileprivate func auraGlow(_ color: Color) -> some View {
        modifier(AuraGlowModifier(color: color))
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @Environment(AppTheme.self) private var theme
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showAboutUNP = false
    @State private var showTierDetail = false
    @State private var showActivityHistory = false

    init() {
        let di = DIContainer.shared
        _viewModel = State(initialValue: ProfileViewModel(
            fetchCurrentUserUseCase: di.makeFetchCurrentUserUseCase(),
            fetchRewardUseCase: di.makeFetchRewardUseCase()
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    skeletonContent
                } else if let user = viewModel.user {
                    profileContent(user)
                }
            }
            .background(theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { profileToolbar }
            .task { await viewModel.loadProfile() }
            .navigationDestination(isPresented: $showSettings) {
                SettingsDetailView()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(prefillName: viewModel.user?.name ?? "") {}
            }
            .sheet(isPresented: $showAboutUNP) {
                AboutUNPView()
            }
            .sheet(isPresented: $viewModel.showAuraPortal) {
                AuraPortalView(reward: viewModel.reward)
                    .environment(theme)
            }
            .sheet(isPresented: $showTierDetail) {
                if let reward = viewModel.reward {
                    AuraTierDetailView(reward: reward)
                        .environment(theme)
                }
            }
            .sheet(isPresented: $showActivityHistory) {
                if let reward = viewModel.reward {
                    AuraActivityHistoryView(reward: reward)
                        .environment(theme)
                }
            }
        }
    }

    // MARK: Toolbar
    private var profileToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                Text("Profile")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: UNPSpacing.xs) {
                    ThemeToggleButton()
                    Button {
                        showAboutUNP = true
                    } label: {
                        Text("About UNP")
                            .font(UNPFontStyle.caption())
                            .foregroundStyle(UNPColor.ember)
                            .padding(.horizontal, UNPSpacing.sm)
                            .padding(.vertical, 5)
                            .background(UNPColor.ember.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: Content
    private func profileContent(_ user: User) -> some View {
        VStack(spacing: UNPSpacing.lg) {
            photoSection(user)
            if let reward = viewModel.reward {
                auraCard(reward)
            }
            menuSection
        }
        .padding(UNPSpacing.md)
    }

    private func photoSection(_ user: User) -> some View {
        VStack(spacing: UNPSpacing.sm) {
            ProfileHeaderCard(
                name: user.name,
                location: "Detroit, Michigan",
                imageURL: user.avatarURL,
                onEditPhoto: { showEditProfile = true }
            )
            basicInfoCard(user)
        }
    }

    private func basicInfoCard(_ user: User) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Basic Information")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .padding(.bottom, UNPSpacing.sm)

            infoRow(label: "Name", value: user.name)
            Divider().background(UNPColor.surface)
            infoRow(label: "Email", value: user.email)
            Divider().background(UNPColor.surface)
            infoRow(label: "Location", value: "Detroit, Michigan")
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text(value.isEmpty ? "—" : value)
                .font(UNPFontStyle.body())
                .foregroundStyle(value.isEmpty ? UNPColor.textMuted : UNPColor.textSecondary)
        }
        .padding(.vertical, UNPSpacing.sm)
    }

    // MARK: - Aura Card (three independent tappable zones)
    private func auraCard(_ reward: Reward) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: UNPRadius.large)
                .fill(UNPColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.large)
                        .stroke(reward.tier.color.opacity(0.28), lineWidth: 1)
                )
            reward.tier.color.opacity(0.04)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))

            VStack(alignment: .leading, spacing: 0) {

                // ── Zone 1: Points balance → Aura Portal ──────────────────
                Button { viewModel.showAuraPortal = true } label: {
                    pointsZone(reward)
                }
                .buttonStyle(AuraZoneButtonStyle())

                auraCardDivider

                // ── Zone 2: Tier + progress → Tier Detail ────────────────
                Button { showTierDetail = true } label: {
                    tierZone(reward)
                }
                .buttonStyle(AuraZoneButtonStyle())

                auraCardDivider

                // ── Zone 3: Recent activity → Activity History ────────────
                if !reward.history.isEmpty {
                    Button { showActivityHistory = true } label: {
                        activityZone(reward)
                    }
                    .buttonStyle(AuraZoneButtonStyle())
                }
            }
        }
    }

    // Zone 1 — points
    private func pointsZone(_ reward: Reward) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                HStack(spacing: UNPSpacing.xs) {
                    Text("✦")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(UNPColor.ember)
                    Text("AURA")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.ember)
                        .tracking(2)
                }
                HStack(alignment: .firstTextBaseline, spacing: UNPSpacing.xs) {
                    Text("\(reward.points)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text("pts")
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textMuted)
                        .padding(.bottom, 3)
                }
                if viewModel.user?.isAmbassador == true {
                    TagBadge(text: "Ambassador", color: UNPColor.ember)
                }
            }

            Spacer()

            HStack(spacing: UNPSpacing.xs) {
                Text("View Portal")
                    .font(UNPFontStyle.label(11))
                    .foregroundStyle(UNPColor.textMuted)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(UNPColor.textMuted)
            }
        }
        .padding(UNPSpacing.md)
        .contentShape(Rectangle())
        .auraGlow(UNPColor.ember)
    }

    // Zone 2 — tier + progress
    private func tierZone(_ reward: Reward) -> some View {
        VStack(spacing: UNPSpacing.sm) {
            HStack {
                tierPill(reward.tier)
                Spacer()
                HStack(spacing: UNPSpacing.xs) {
                    Text("Tier Details")
                        .font(UNPFontStyle.label(11))
                        .foregroundStyle(UNPColor.textMuted)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
            AuraTierProgressBar(points: reward.points, tier: reward.tier)
        }
        .padding(UNPSpacing.md)
        .contentShape(Rectangle())
        .auraGlow(reward.tier.color)
    }

    // Zone 3 — activity
    private func activityZone(_ reward: Reward) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text("Recent Activity")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                    .textCase(.uppercase)
                    .tracking(0.8)
                Spacer()
                HStack(spacing: UNPSpacing.xs) {
                    Text("See All")
                        .font(UNPFontStyle.label(11))
                        .foregroundStyle(UNPColor.azure)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(UNPColor.azure)
                }
            }
            ForEach(reward.history.prefix(3)) { tx in
                activityRow(tx)
            }
        }
        .padding(UNPSpacing.md)
        .contentShape(Rectangle())
        .auraGlow(UNPColor.azure)
    }

    // ── Sub-views ──────────────────────────────────────────────────────────
    private var auraCardDivider: some View {
        Rectangle()
            .fill(UNPColor.surfaceElevated.opacity(0.6))
            .frame(height: 1)
            .padding(.horizontal, UNPSpacing.md)
    }

    private func activityRow(_ tx: RewardTransaction) -> some View {
        HStack {
            Image(systemName: "bolt.fill")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(UNPColor.azure)
            Text(tx.description)
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
                .lineLimit(1)
            Spacer()
            Text("+\(tx.points)")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.azure)
        }
    }

    private func tierPill(_ tier: RewardTier) -> some View {
        HStack(spacing: 4) {
            Image(systemName: tier.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(tier.displayName)
                .font(UNPFontStyle.label())
        }
        .foregroundStyle(tier.color)
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, 4)
        .background(tier.color.opacity(0.15))
        .clipShape(Capsule())
    }

    // MARK: - Menu
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.lg) {
            settingsGroup(header: "Account") {
                NavRow(icon: "creditcard.fill", label: "Payment Methods") {}
                Divider().background(UNPColor.surfaceElevated).padding(.leading, UNPSpacing.lg)
                NavRow(icon: "location.fill", label: "Saved Addresses") {}
                Divider().background(UNPColor.surfaceElevated).padding(.leading, UNPSpacing.lg)
                NavRow(icon: "bell.fill", label: "Notifications") {}
            }

            settingsGroup(header: "Preferences") {
                NavRow(icon: "location.circle.fill", label: "Location Services") {}
                Divider().background(UNPColor.surfaceElevated).padding(.leading, UNPSpacing.lg)
                NavRow(icon: "paintbrush.fill", label: "Appearance") {}
                Divider().background(UNPColor.surfaceElevated).padding(.leading, UNPSpacing.lg)
                NavRow(icon: "globe", label: "Language") {}
            }

            settingsGroup(header: "Support") {
                NavRow(icon: "questionmark.circle.fill", label: "Help & Support") {}
            }
        }
    }

    private func settingsGroup<Content: View>(header: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text(header)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .padding(.horizontal, 4)
            VStack(spacing: 0) {
                content()
            }
            .unpCard()
        }
    }

    // MARK: - Skeleton
    private var skeletonContent: some View {
        VStack(spacing: UNPSpacing.md) {
            VStack(spacing: UNPSpacing.sm) {
                SkeletonView(width: 88, height: 88, radius: UNPRadius.pill)
                SkeletonView(width: 120, height: 14)
            }
            .padding(.top, UNPSpacing.md)
            SkeletonCardView()
            SkeletonCardView()
        }
        .padding(UNPSpacing.md)
    }
}
