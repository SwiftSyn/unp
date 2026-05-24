import SwiftUI

struct PourCircleView: View {
    @State private var viewModel: ProfileViewModel
    @Environment(AppTheme.self) private var theme
    @State private var showEditProfile = false
    @State private var showFavorites = false
    @State private var showAllCircles = false
    @State private var showCommunity = false
    @State private var showMessage = false
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
                        header(user)
                        statsRow
                        Divider().background(UNPColor.surface).padding(.vertical, UNPSpacing.md)
                        circlesSection
                        Divider().background(UNPColor.surface).padding(.vertical, UNPSpacing.md)
                        communityFeedSection
                        Divider().background(UNPColor.surface).padding(.vertical, UNPSpacing.md)
                        communitySection
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
            .task {
                await viewModel.loadProfile()
                let di = DIContainer.shared
                if let loaded = try? await di.makeFetchCirclesUseCase().execute() { circles = loaded }
                if let loaded = try? await di.makeFetchPostsUseCase().execute() { posts = loaded }
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(prefillName: viewModel.user?.name ?? "") {}
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .sheet(isPresented: $showMessage) {
            MessageSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .sheet(item: $selectedCircle) { circle in
            CircleDetailSheet(circle: circle)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    private func header(_ user: User) -> some View {
        VStack(spacing: UNPSpacing.md) {
            ZStack(alignment: .bottomTrailing) {
                Button { showEditProfile = true } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UNPColor.neon.opacity(0.3), UNPColor.ember.opacity(0.2)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 88, height: 88)
                        Image(systemName: "person.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(UNPColor.textMuted)
                    }
                }
                .buttonStyle(.plain)

                ZStack {
                    Circle()
                        .fill(UNPColor.emberGradient)
                        .frame(width: 28, height: 28)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                }
            }

            Text(user.name.isEmpty ? "Your Name" : user.name)
                .font(UNPFontStyle.heading(18))
                .foregroundStyle(UNPColor.textPrimary)

            Button { showMessage = true } label: {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 14))
                    Text("Message")
                        .font(UNPFontStyle.caption())
                    ZStack(alignment: .topTrailing) {
                        Color.clear.frame(width: 8, height: 8)
                        Circle()
                            .fill(UNPColor.error)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
                .foregroundStyle(.black)
                .padding(.horizontal, UNPSpacing.lg)
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.emberGradient)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.top, UNPSpacing.md)
        .padding(.bottom, UNPSpacing.sm)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(value: "12", label: "Messages", icon: "envelope.fill", iconColor: UNPColor.ember, badge: true)
            divider
            statCell(value: "8", label: "Originals", icon: "play.circle.fill", iconColor: UNPColor.neon)
            divider
            statCell(value: "3", label: "Ambassadors", icon: "star.fill", iconColor: UNPColor.gold)
            divider
            statCell(value: "4.8", label: "Rating", icon: "heart.fill", iconColor: UNPColor.error)
        }
        .padding(UNPSpacing.md)
        .unpCard(background: UNPColor.surface)
        .padding(.horizontal, UNPSpacing.md)
    }

    private func statCell(value: String, label: String, icon: String, iconColor: Color, badge: Bool = false) -> some View {
        VStack(spacing: 4) {
            IconBadge(systemName: icon, color: iconColor, size: 28, backgroundColor: iconColor.opacity(0.12))
            ZStack(alignment: .topTrailing) {
                Text(value)
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.ember)
                if badge {
                    Circle()
                        .fill(UNPColor.error)
                        .frame(width: 8, height: 8)
                        .offset(x: 4, y: -2)
                }
            }
            Text(label)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(UNPColor.textMuted.opacity(0.2))
            .frame(width: 1, height: 40)
    }

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

    private var communitySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Community")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .padding(.horizontal, UNPSpacing.lg)
                .padding(.bottom, UNPSpacing.sm)

            NavRow(icon: "person.crop.circle", label: "Edit Profile") {
                showEditProfile = true
            }
            Divider()
                .background(UNPColor.surface)
                .padding(.leading, UNPSpacing.lg + 26 + UNPSpacing.md)
            NavRow(icon: "heart", label: "Favorites") {
                showFavorites = true
            }
        }
        .padding(.top, UNPSpacing.sm)
    }

    private var skeletonContent: some View {
        VStack(spacing: UNPSpacing.md) {
            VStack(spacing: UNPSpacing.sm) {
                SkeletonView(width: 88, height: 88, radius: UNPRadius.pill)
                SkeletonView(width: 120, height: 14)
                SkeletonView(width: 80, height: 11)
            }
            .padding(.top, UNPSpacing.md)
            HStack {
                ForEach(0..<4, id: \.self) { _ in SkeletonView(height: 44) }
            }
            .padding(.horizontal)
            SkeletonCardView()
                .padding(.horizontal)
        }
    }
}

private struct FavoritesSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: UNPSpacing.xl) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(UNPColor.ember)
                Text("No Favorites Yet")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Like posts and pours to save them here")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(UNPColor.background)
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundStyle(UNPColor.ember)
                }
            }
        }
    }
}

private struct MessageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: UNPSpacing.sm) {
                        messageRow(name: "Maya", text: "Who's doing the riverfront spritz first?", time: "9:14 PM")
                        messageRow(name: "Jordan", text: "Stirred room at 9 — meet at the mural.", time: "9:18 PM")
                        messageRow(name: "UNP", text: "Tonight's plan link dropped in Paid tier.", time: "9:20 PM")
                    }
                    .padding(UNPSpacing.md)
                }

                HStack(spacing: UNPSpacing.sm) {
                    TextField("Message…", text: $messageText)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textPrimary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, UNPSpacing.md)
                        .background(UNPColor.surface)
                        .clipShape(Capsule())

                    Button {} label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(UNPColor.ember)
                    }
                }
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.surfaceElevated)
            }
            .background(UNPColor.background)
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundStyle(UNPColor.ember)
                }
            }
        }
    }

    private func messageRow(name: String, text: String, time: String) -> some View {
        HStack(alignment: .top, spacing: UNPSpacing.sm) {
            AvatarView(name: name, imageURL: nil, size: 38)
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(name)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                    Spacer()
                    Text(time)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                }
                Text(text)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}
