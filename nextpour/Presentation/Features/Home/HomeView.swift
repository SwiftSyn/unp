import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @Environment(AppTheme.self) private var theme
    @State private var showPourJourney = false
    @State private var showNextMoveJourney = false
    @State private var showExploreJourney = false

    init() {
        let di = DIContainer.shared
        _viewModel = State(initialValue: HomeViewModel(
            fetchPostsUseCase: di.makeFetchPostsUseCase(),
            fetchEventsUseCase: di.makeFetchEventsUseCase(),
            fetchBartendersUseCase: di.makeFetchBartendersUseCase(),
            toggleLikeUseCase: di.makeTogglePostLikeUseCase()
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                UNPColor.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        greetingHeader
                            .padding(.horizontal, UNPSpacing.md)
                            .padding(.top, UNPSpacing.sm)

                        journeyPillsRow
                            .padding(.top, UNPSpacing.lg)

                        if let error = viewModel.errorMessage {
                            ErrorStateView(
                                message: error,
                                onRetry: { Task { await viewModel.loadFeed() } }
                            )
                            .padding(.top, UNPSpacing.xl)
                        } else {
                            bodyCards
                                .padding(.top, UNPSpacing.lg)
                                .padding(.bottom, UNPSpacing.xxl)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task { await viewModel.loadFeed() }
            .refreshable { await viewModel.loadFeed() }
            .navigationDestination(isPresented: $showPourJourney) { PourJourneyView() }
            .navigationDestination(isPresented: $showNextMoveJourney) { NextMoveJourneyView() }
            .navigationDestination(isPresented: $showExploreJourney) {
                ExploreJourneyView(initialEvent: viewModel.featuredEvents.first)
            }
        }
    }

    private var greetingHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(timeGreeting)
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textMuted)
                Text("Your Next Pour")
                    .font(UNPFontStyle.display(28))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            Spacer()
            HStack(spacing: UNPSpacing.sm) {
                ThemeToggleButton()
                Image("UNPLoginMark")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .opacity(0.9)
            }
        }
    }

    private var journeyPillsRow: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("JOURNEYS")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .tracking(0.8)
                .padding(.horizontal, UNPSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    Spacer().frame(width: UNPSpacing.xs)
                    JourneyPill(icon: "wineglass.fill", label: "The Pour", gradient: UNPColor.emberGradient) {
                        showPourJourney = true
                    }
                    JourneyPill(icon: "moon.stars.fill", label: "Your Next Move", gradient: UNPColor.neonGradient) {
                        showNextMoveJourney = true
                    }
                    JourneyPill(icon: "map.fill", label: "The Explore", gradient: LinearGradient(
                        colors: [UNPColor.azure, UNPColor.azureLight.opacity(0.7)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )) {
                        showExploreJourney = true
                    }
                    Spacer().frame(width: UNPSpacing.xs)
                }
            }
        }
    }

    private var bodyCards: some View {
        VStack(spacing: UNPSpacing.md) {
            if viewModel.isLoading {
                skeletonFeed
            } else {
                beverageOfDayCard
                tonightsMoveCard
                eventsNearYouCard
            }
        }
        .padding(.horizontal, UNPSpacing.md)
    }

    private var beverageOfDayCard: some View {
        Button { showPourJourney = true } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                    .fill(UNPColor.surface)
                    .frame(height: 200)

                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                        .fill(
                            LinearGradient(
                                colors: [UNPColor.ember.opacity(0.18), UNPColor.neon.opacity(0.08), UNPColor.surface],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                    Image(systemName: "wineglass.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(UNPColor.ember.opacity(0.15))
                        .offset(x: 80, y: -10)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

                LinearGradient(
                    colors: [UNPColor.surface.opacity(0.98), .clear],
                    startPoint: .bottom,
                    endPoint: .center
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

                if viewModel.isLoading {
                    VStack(alignment: .leading, spacing: 8) {
                        SkeletonView(width: 160, height: 18, radius: UNPRadius.small)
                        SkeletonView(width: 240, height: 22, radius: UNPRadius.small)
                        SkeletonView(width: 200, height: 14, radius: UNPRadius.small)
                    }
                    .padding(UNPSpacing.lg)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        LabelChip(text: "BEVERAGE OF THE DAY", icon: "sparkles", color: UNPColor.ember)
                        Text("Midnight Old Fashioned")
                            .font(UNPFontStyle.display(22))
                            .foregroundStyle(UNPColor.textPrimary)
                        Text("Smoked bourbon, demerara, aromatic bitters")
                            .font(UNPFontStyle.body(13))
                            .foregroundStyle(UNPColor.textSecondary)
                            .lineLimit(1)
                        Text("Pour →")
                            .font(UNPFontStyle.caption())
                            .foregroundStyle(UNPColor.ember)
                    }
                    .padding(UNPSpacing.lg)
                }
            }
        }
        .buttonStyle(.plain)
        .unpShadow(UNPShadow.card)
    }

    private var tonightsMoveCard: some View {
        Button { showNextMoveJourney = true } label: {
            HStack(spacing: UNPSpacing.md) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [UNPColor.neon.opacity(0.25), UNPColor.neonDeep.opacity(0.12)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(UNPColor.neonLight)
                }

                VStack(alignment: .leading, spacing: 4) {
                    LabelChip(text: "TONIGHT'S MOVE", color: UNPColor.neon)
                    Text("Tonight's Move")
                        .font(UNPFontStyle.heading(16))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text("Curated for Detroit — March rhythm")
                        .font(UNPFontStyle.caption(12))
                        .foregroundStyle(UNPColor.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                ChevronRight()
            }
            .padding(UNPSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: UNPRadius.large)
                    .fill(UNPColor.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: UNPRadius.large)
                            .stroke(UNPColor.neon.opacity(0.25), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var eventsNearYouCard: some View {
        Button { showExploreJourney = true } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: UNPSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [UNPColor.azure.opacity(0.25), UNPColor.azure.opacity(0.08)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 52, height: 52)
                        Image(systemName: "location.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(UNPColor.azure)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        LabelChip(text: "EVENTS NEAR YOU", color: UNPColor.azure)
                        Text(viewModel.featuredEvents.first?.title ?? "Riverfront Jazz & Spritz")
                            .font(UNPFontStyle.heading(16))
                            .foregroundStyle(UNPColor.textPrimary)
                        Text(viewModel.featuredEvents.first?.venueName ?? "Atwater Deck")
                            .font(UNPFontStyle.caption(12))
                            .foregroundStyle(UNPColor.textSecondary)
                    }
                    Spacer()
                    ChevronRight()
                }
                .padding(UNPSpacing.md)

                if !viewModel.featuredEvents.isEmpty {
                    Divider()
                        .background(UNPColor.surfaceElevated)
                        .padding(.leading, UNPSpacing.md + 52 + UNPSpacing.md)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: UNPSpacing.sm) {
                            ForEach(viewModel.featuredEvents.prefix(4)) { event in
                                eventMiniChip(event)
                            }
                        }
                        .padding(.horizontal, UNPSpacing.md)
                        .padding(.vertical, UNPSpacing.sm)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: UNPRadius.large)
                    .fill(UNPColor.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: UNPRadius.large)
                            .stroke(UNPColor.azure.opacity(0.25), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func eventMiniChip(_ event: Event) -> some View {
        HStack(spacing: 5) {
            Text(event.date.formatted(as: "EEE"))
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
            Text(event.title)
                .font(UNPFontStyle.caption(12))
                .foregroundStyle(UNPColor.textSecondary)
                .lineLimit(1)
        }
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, 5)
        .background(UNPColor.surfaceElevated)
        .clipShape(Capsule())
    }

    private var skeletonFeed: some View {
        VStack(spacing: UNPSpacing.md) {
            SkeletonView(height: 200, radius: UNPRadius.extraLarge)
            SkeletonView(height: 80, radius: UNPRadius.large)
            SkeletonView(height: 100, radius: UNPRadius.large)
        }
    }

    private var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let day = Date().formatted(.dateTime.weekday(.wide).month().day())
        switch hour {
        case 5..<12: return "Good morning · \(day)"
        case 12..<17: return "Good afternoon · \(day)"
        case 17..<21: return "Good evening · \(day)"
        default: return "Late night · \(day)"
        }
    }
}

private struct JourneyPill: View {
    let icon: String
    let label: String
    let gradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UNPSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text(label)
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.sm + 2)
            .background(gradient)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
