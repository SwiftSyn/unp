import SwiftUI

struct PourCircleView: View {
    @State private var viewModel: ProfileViewModel
    @Environment(AppTheme.self) private var theme
    @State private var showAllCircles = false
    @State private var showCommunity = false
    @State private var showMessages = false
    @State private var showOriginals = false
    @State private var showAmbassadors = false
    @State private var showRating = false
    @State private var showAura = false
    @State private var selectedCircle: PourCircle?
    @State private var circles: [PourCircle] = []
    @State private var posts: [Post] = []

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
                VStack(spacing: 0) {
                    if let user = viewModel.user {
                        ProfileHeaderCard(
                            name: user.name,
                            location: "Detroit, Michigan",
                            imageURL: user.avatarURL
                        )
                        .padding(.top, UNPSpacing.md)
                        .padding(.bottom, UNPSpacing.sm)
                        statsRow
                        Divider().background(UNPColor.surface).padding(.vertical, UNPSpacing.md)
                        circlesSection
                        Divider().background(UNPColor.surface).padding(.vertical, UNPSpacing.md)
                        communityFeedSection
                        Spacer().frame(height: UNPSpacing.xxl)
                    } else if viewModel.isLoading {
                        skeletonContent
                    }
                }
            }
            .background(theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pour Circle")
                        .font(UNPFontStyle.heading())
                        .foregroundStyle(UNPColor.textPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ThemeToggleButton()
                }
            }
            .navigationDestination(isPresented: $showAllCircles) { CirclesView() }
            .navigationDestination(isPresented: $showCommunity) { CommunityView() }
            .navigationDestination(isPresented: $showMessages) { CommunityView() }
            .navigationDestination(isPresented: $showOriginals) { OriginalsView() }
            .navigationDestination(isPresented: $showAmbassadors) { AmbassadorView() }
            .navigationDestination(isPresented: $showRating) { RatingView() }
            .navigationDestination(isPresented: $showAura) { AuraPortalView(reward: viewModel.reward) }
            .task {
                await viewModel.loadProfile()
                let di = DIContainer.shared
                if let loaded = try? await di.makeFetchCirclesUseCase().execute() { circles = loaded }
                if let loaded = try? await di.makeFetchPostsUseCase().execute() { posts = loaded }
            }
        }
        .sheet(item: $selectedCircle) { circle in
            CircleDetailSheet(circle: circle)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(value: "12", label: "Messages", icon: "envelope.fill", iconColor: UNPColor.ember, badge: true) {
                showMessages = true
            }
            divider
            statCell(value: "8", label: "Originals", icon: "play.circle.fill", iconColor: UNPColor.neon) {
                showOriginals = true
            }
            divider
            statCell(value: "3", label: "Ambassadors", icon: "crown.fill", iconColor: UNPColor.gold) {
                showAmbassadors = true
            }
            divider
            statCell(value: "4.8", label: "Rating", icon: "heart.fill", iconColor: UNPColor.error) {
                showRating = true
            }
            divider
            statCell(value: viewModel.reward.map { "\($0.points)" } ?? "—", label: "Aura", icon: "sparkles", iconColor: UNPColor.violet) {
                showAura = true
            }
        }
        .padding(.vertical, UNPSpacing.md)
        .unpCard(background: UNPColor.surface)
        .padding(.horizontal, UNPSpacing.md)
        .padding(.top, UNPSpacing.sm)
    }

    private func statCell(value: String, label: String, icon: String, iconColor: Color, badge: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                IconBadge(systemName: icon, color: iconColor, size: 26, backgroundColor: iconColor.opacity(0.12))
                ZStack(alignment: .topTrailing) {
                    Text(value)
                        .font(UNPFontStyle.heading(14))
                        .foregroundStyle(UNPColor.ember)
                    if badge {
                        Circle()
                            .fill(UNPColor.error)
                            .frame(width: 7, height: 7)
                            .offset(x: 4, y: -2)
                    }
                }
                Text(label)
                    .font(UNPFontStyle.label(10))
                    .foregroundStyle(UNPColor.textMuted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var divider: some View {
        Rectangle()
            .fill(UNPColor.textMuted.opacity(0.2))
            .frame(width: 1, height: 40)
    }

    // MARK: - Circles Section

    private var circlesSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text("Your Circles")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                Spacer()
                Button { showAllCircles = true } label: {
                    Text("See All")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.bottom, 2)

            Group {
                if circles.isEmpty {
                    SkeletonRowView().padding(.horizontal, UNPSpacing.md)
                } else {
                    VStack(spacing: UNPSpacing.sm) {
                        ForEach(circles.prefix(3)) { circle in
                            Button { selectedCircle = circle } label: {
                                CircleCard(circle: circle, onJoin: {})
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, UNPSpacing.md)
                        }
                    }
                }
            }
            .padding(.bottom, UNPSpacing.xs)
        }
    }

    // MARK: - Community Feed

    private var communityFeedSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text("Community Feed")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                Spacer()
                Button { showCommunity = true } label: {
                    Text("See All")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.bottom, 2)

            Group {
                if posts.isEmpty {
                    VStack(spacing: UNPSpacing.sm) {
                        ForEach(0..<2, id: \.self) { _ in SkeletonRowView() }
                    }
                    .padding(.horizontal, UNPSpacing.md)
                } else {
                    VStack(spacing: UNPSpacing.sm) {
                        ForEach(posts.prefix(3)) { post in
                            PostCard(post: post)
                                .padding(.horizontal, UNPSpacing.md)
                        }
                    }
                }
            }
            .padding(.bottom, UNPSpacing.xs)
        }
    }

    // MARK: - Skeleton

    private var skeletonContent: some View {
        VStack(spacing: UNPSpacing.md) {
            VStack(spacing: UNPSpacing.sm) {
                SkeletonView(width: 88, height: 88, radius: UNPRadius.pill)
                SkeletonView(width: 120, height: 14)
                SkeletonView(width: 80, height: 11)
            }
            .padding(.top, UNPSpacing.md)
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { _ in SkeletonView(height: 60).frame(maxWidth: .infinity) }
            }
            .padding(.horizontal)
            SkeletonCardView()
                .padding(.horizontal)
        }
    }
}
