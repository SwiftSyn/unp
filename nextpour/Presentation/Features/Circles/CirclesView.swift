import SwiftUI

struct CirclesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CirclesViewModel
    @State private var searchText = ""
    @State private var showJoined = false
    @State private var selectedCircle: PourCircle?

    init() {
        _viewModel = State(initialValue: CirclesViewModel(
            fetchCirclesUseCase: DIContainer.shared.makeFetchCirclesUseCase()
        ))
    }

    private var filteredCircles: [PourCircle] {
        let base = showJoined ? viewModel.circles.filter { $0.isMember } : viewModel.circles
        guard !searchText.isEmpty else { return base }
        return base.filter { $0.name.localizedCaseInsensitiveContains(searchText) ||
                              $0.description.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(text: $searchText, placeholder: "Search circles…")
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.background)

            filterBar
                .padding(.horizontal, UNPSpacing.md)
                .padding(.bottom, UNPSpacing.sm)
                .background(UNPColor.background)

            Group {
                if viewModel.isLoading {
                    ScrollView {
                        VStack(spacing: UNPSpacing.sm) {
                            ForEach(0..<4, id: \.self) { _ in SkeletonRowView() }
                        }
                        .padding(UNPSpacing.md)
                    }
                } else if filteredCircles.isEmpty {
                    ContentUnavailableView {
                        Label("No Circles Found", systemImage: "person.3")
                    } description: {
                        Text(showJoined ? "You haven't joined any circles yet." : "No circles matched your search.")
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: UNPSpacing.sm) {
                            ForEach(filteredCircles) { circle in
                                Button { selectedCircle = circle } label: {
                                    CircleCard(circle: circle, onJoin: {})
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(UNPSpacing.md)
                    }
                }
            }
        }
        .background(UNPColor.background)
        .navigationTitle("Circles")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.copper)
                }
            }
        }
        .task { await viewModel.loadCircles() }
        .sheet(item: $selectedCircle) { circle in
            CircleDetailSheet(circle: circle)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    private var filterBar: some View {
        HStack(spacing: UNPSpacing.sm) {
            filterChip("All", isSelected: !showJoined) { showJoined = false }
            filterChip("Joined", isSelected: showJoined) { showJoined = true }
            Spacer()
            Text("\(filteredCircles.count) circles")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
        }
    }

    private func filterChip(_ label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(UNPFontStyle.caption())
                .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                .padding(.horizontal, UNPSpacing.sm)
                .padding(.vertical, 6)
                .background(isSelected ? UNPColor.copper : UNPColor.surface)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct CircleDetailSheet: View {
    let circle: PourCircle
    @Environment(\.dismiss) private var dismiss

    private let recentActivity: [(String, String, String)] = [
        ("Miranda L.", "Saved Midnight Old Fashioned", "2m ago"),
        ("Chef Andre", "Posted a new copper pour recipe", "14m ago"),
        ("J. Rivers", "RSVP'd to Riverfront Jazz & Spritz", "1h ago"),
        ("Antonia V.", "Shared a pour from PORT", "2h ago")
    ]

    var body: some View {
        VStack(spacing: 0) {
            DrawerHandle()
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(UNPColor.textSecondary)
                        .padding(8)
                        .background(UNPColor.surface)
                        .clipShape(SwiftUI.Circle())
                }
                Spacer()
                Text(circle.name)
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                    .lineLimit(1)
                Spacer()
                Color.clear.frame(width: 36)
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.top, UNPSpacing.md)

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    circleHero
                    activitySection
                }
                .padding(UNPSpacing.lg)
            }
        }
    }

    private var circleHero: some View {
        VStack(spacing: UNPSpacing.md) {
            ZStack {
                SwiftUI.Circle()
                    .fill(UNPColor.violet.opacity(0.15))
                    .frame(width: 72, height: 72)
                Image(systemName: "person.3.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(UNPColor.violet)
            }
            Text(circle.description)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textSecondary)
                .multilineTextAlignment(.center)
            HStack(spacing: UNPSpacing.lg) {
                VStack(spacing: 2) {
                    Text("\(circle.memberCount)")
                        .font(UNPFontStyle.heading(18))
                        .foregroundStyle(UNPColor.copper)
                    Text("Members")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                }
                VStack(spacing: 2) {
                    Text(circle.isMember ? "Joined" : "Open")
                        .font(UNPFontStyle.heading(18))
                        .foregroundStyle(circle.isMember ? UNPColor.success : UNPColor.copper)
                    Text("Status")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
            .padding(UNPSpacing.md)
            .unpCard()
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Recent Activity")
            VStack(spacing: UNPSpacing.sm) {
                ForEach(recentActivity, id: \.0) { name, action, time in
                    HStack(spacing: UNPSpacing.md) {
                        AvatarView(name: name, imageURL: nil, size: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(UNPFontStyle.heading(14))
                                .foregroundStyle(UNPColor.textPrimary)
                            Text(action)
                                .font(UNPFontStyle.caption(12))
                                .foregroundStyle(UNPColor.textSecondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(time)
                            .font(UNPFontStyle.label())
                            .foregroundStyle(UNPColor.textMuted)
                    }
                    .padding(UNPSpacing.sm)
                    .unpCard()
                }
            }
        }
    }
}
