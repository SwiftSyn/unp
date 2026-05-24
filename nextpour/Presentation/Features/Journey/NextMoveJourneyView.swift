import SwiftUI

struct NextMoveJourneyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showMoodSelector = false
    @State private var selectedMoods: Set<UserMood> = []
    @State private var selectedVibe: NudgeVibe? = nil
    @State private var activeTab: MoveTab = .tonight

    enum MoveTab: String, CaseIterable {
        case tonight = "Tonight's Move"
        case circle = "Pour Circle"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            UNPColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    contextBanner
                    tabBar
                    switch activeTab {
                    case .tonight: moveContent
                    case .circle: circleChatContent
                    }
                    Spacer().frame(height: UNPSpacing.xxl)
                }
                .padding(.horizontal, UNPSpacing.md)
                .padding(.top, UNPSpacing.sm)
            }

            if !selectedMoods.isEmpty {
                moodBanner
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.md)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Home", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Tonight's Move")
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showMoodSelector = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 14))
                        Text("User Mood")
                            .font(UNPFontStyle.caption())
                    }
                    .foregroundStyle(UNPColor.neonLight)
                    .padding(.horizontal, UNPSpacing.sm)
                    .padding(.vertical, 6)
                    .background(UNPColor.neon.opacity(0.15))
                    .clipShape(Capsule())
                }
            }
        }
        .sheet(isPresented: $showMoodSelector) {
            MoodSelectorView(selectedMoods: $selectedMoods) { moods in selectedMoods = moods }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedMoods)
    }

    private var contextBanner: some View {
        HStack(spacing: UNPSpacing.sm) {
            Image(systemName: "location.fill")
                .font(.system(size: 11))
                .foregroundStyle(UNPColor.ember)
            Text("Detroit")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
            Text("·")
                .foregroundStyle(UNPColor.textMuted)
            Text(Date().formatted(.dateTime.weekday(.wide).hour().minute()))
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
            Spacer()
            LabelChip(text: "March Rhythm", icon: "music.note", color: UNPColor.ember)
        }
        .padding(.horizontal, 4)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(MoveTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        activeTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(activeTab == tab ? .black : UNPColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UNPSpacing.sm)
                        .background(activeTab == tab ? UNPColor.emberGradient : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(UNPColor.surface)
        .clipShape(Capsule())
    }

    private var moveContent: some View {
        VStack(spacing: UNPSpacing.lg) {
            moveHeroCard
            liveActivityStrip
            vibeSelector
            tonightTimeline
            linkedContent
        }
    }

    private var liveActivityStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: UNPSpacing.sm) {
                liveChip(icon: "person.2.fill", label: "4 friends planning tonight", color: UNPColor.neon)
                liveChip(icon: "calendar.badge.clock", label: "6 events tonight", color: UNPColor.ember)
                liveChip(icon: "wineglass.fill", label: "Chef Andre pouring at 9", color: UNPColor.azure)
            }
        }
    }

    private func liveChip(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            Text(label)
                .font(UNPFontStyle.caption(12))
                .foregroundStyle(UNPColor.textSecondary)
        }
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, UNPSpacing.xs)
        .background(UNPColor.surface)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.2), lineWidth: 1))
    }

    private var moveHeroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(
                    LinearGradient(
                        colors: [UNPColor.neon.opacity(0.15), UNPColor.midnightRich, UNPColor.surface],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(minHeight: 160)
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                        .stroke(UNPColor.neon.opacity(0.3), lineWidth: 1)
                )

            Image(systemName: "moon.stars.fill")
                .font(.system(size: 90))
                .foregroundStyle(UNPColor.neon.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(UNPSpacing.lg)

            VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                LabelChip(text: "TONIGHT'S MOVE", icon: "sparkles", color: UNPColor.neon)
                Text("Tonight's Move")
                    .font(UNPFontStyle.display(22))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Start with a bitter spritz, slide into a stirred cocktail, end with a highball.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                Text("Curated for Detroit — March rhythm")
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
            }
            .padding(UNPSpacing.lg)
        }
    }

    private var vibeSelector: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Pick your vibe")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    ForEach(NudgeVibe.allCases) { vibe in
                        VibeCard(
                            vibe: vibe,
                            isSelected: selectedVibe == vibe,
                            action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                    selectedVibe = selectedVibe == vibe ? nil : vibe
                                }
                            }
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
    }

    private var tonightTimeline: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Tonight's Plan")

            VStack(spacing: 0) {
                ForEach(Array(tonightSteps.enumerated()), id: \.offset) { index, step in
                    TimelineStep(
                        time: step.0,
                        title: step.1,
                        subtitle: step.2,
                        isLast: index == tonightSteps.count - 1
                    )
                }
            }
            .padding(UNPSpacing.md)
            .unpCard()
        }
    }

    private var tonightSteps: [(String, String, String)] {
        [
            ("7:30 PM", "Spritz at the riverfront patio", "Riverfront Jazz & Spritz · Atwater Deck · 3 friends going"),
            ("9:00 PM", "Stirred classic at the lounge", "Midnight Old Fashioned · The Nest Bar · Chef Andre pouring"),
            ("11:30 PM", "Highball at the late room", "Late Night Session · PORT · 12 RSVPs")
        ]
    }

    private var linkedContent: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Linked")
            HStack(spacing: UNPSpacing.sm) {
                linkedChip(icon: "calendar", label: "Riverfront Jazz", color: UNPColor.azure)
                linkedChip(icon: "wineglass.fill", label: "Midnight Old Fashioned", color: UNPColor.ember)
            }
        }
    }

    private func linkedChip(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11)).foregroundStyle(color)
            Text(label).font(UNPFontStyle.caption(12)).foregroundStyle(UNPColor.textSecondary).lineLimit(1)
        }
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, UNPSpacing.xs)
        .background(UNPColor.surface)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
    }

    private var moodBanner: some View {
        HStack(spacing: UNPSpacing.sm) {
            ForEach(Array(selectedMoods.prefix(3)), id: \.self) { mood in
                HStack(spacing: 3) {
                    Image(systemName: mood.icon).font(.system(size: 10))
                    Text(mood.label).font(UNPFontStyle.label())
                }
                .foregroundStyle(UNPColor.neonLight)
            }
            if selectedMoods.count > 3 {
                Text("+\(selectedMoods.count - 3)").font(UNPFontStyle.label()).foregroundStyle(UNPColor.textMuted)
            }
            Spacer()
            Button { selectedMoods.removeAll() } label: {
                Image(systemName: "xmark").font(.system(size: 11)).foregroundStyle(UNPColor.textMuted)
            }
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    private var circleChatContent: some View {
        VStack(spacing: UNPSpacing.lg) {
            circleSummaryCard
            chatSection
            rewardsSection
        }
    }

    private var circleSummaryCard: some View {
        CircleCard(
            circle: PourCircle(
                id: "c1",
                name: "Detroit Pour Collective",
                description: "12 saves · 4 RSVPs in the last hour",
                memberCount: 48,
                imageURL: nil,
                lastActivity: Date(),
                isMember: true
            )
        )
    }

    private var chatSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Group Chat")

            VStack(spacing: UNPSpacing.sm) {
                chatBubble(name: "Maya", message: "Who's doing the riverfront spritz first?", isMine: false)
                chatBubble(name: "Jordan", message: "Stirred room at 9 — meet at the mural.", isMine: false)
                chatBubble(name: "UNP", message: "Tonight's plan link dropped in Paid tier.", isMine: false, isSystem: true)
            }
        }
    }

    private func chatBubble(name: String, message: String, isMine: Bool, isSystem: Bool = false) -> some View {
        HStack(alignment: .bottom, spacing: UNPSpacing.sm) {
            if !isMine {
                AvatarView(name: name, imageURL: nil, size: 30)
            }
            VStack(alignment: isMine ? .trailing : .leading, spacing: 3) {
                if !isMine && !isSystem {
                    Text(name)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.ember)
                }
                Text(message)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textPrimary)
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.vertical, UNPSpacing.sm)
                    .background(isSystem ? LinearGradient(colors: [UNPColor.neon.opacity(0.15), UNPColor.neon.opacity(0.15)], startPoint: .top, endPoint: .bottom) : (isMine ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.surface, UNPColor.surface], startPoint: .top, endPoint: .bottom)))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .frame(maxWidth: .infinity, alignment: isMine ? .trailing : .leading)
            if isMine {
                AvatarView(name: "Me", imageURL: nil, size: 30)
            }
        }
    }

    private var rewardsSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Rewards")
            HStack(spacing: UNPSpacing.md) {
                rewardStat("420", "pts", UNPColor.bronze)
                rewardStat("+25", "saved", UNPColor.azure)
                rewardStat("+50", "plan", UNPColor.ember)
            }
            .padding(UNPSpacing.md)
            .unpCard()
        }
    }

    private func rewardStat(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(UNPFontStyle.heading(17))
                .foregroundStyle(color)
            Text(label)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

enum NudgeVibe: String, CaseIterable, Identifiable {
    case spritzFirst = "Spritz First"
    case stirredFirst = "Stirred First"
    case surpriseMe = "Surprise Me"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .spritzFirst: return "sparkles"
        case .stirredFirst: return "arrow.clockwise"
        case .surpriseMe: return "dice.fill"
        }
    }
    var description: String {
        switch self {
        case .spritzFirst: return "Light and fizzy to start"
        case .stirredFirst: return "Bold and spirit-forward"
        case .surpriseMe: return "Let the night decide"
        }
    }
}

private struct VibeCard: View {
    let vibe: NudgeVibe
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.surfaceElevated, UNPColor.surfaceElevated], startPoint: .top, endPoint: .bottom))
                        .frame(width: 40, height: 40)
                    Image(systemName: vibe.icon)
                        .font(.system(size: 17))
                        .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                }
                Text(vibe.rawValue)
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(vibe.description)
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(UNPSpacing.md)
            .frame(width: 140, alignment: .leading)
            .background(isSelected ? UNPColor.surfaceHigh : UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: UNPRadius.large)
                    .stroke(isSelected ? UNPColor.ember.opacity(0.6) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TimelineStep: View {
    let time: String
    let title: String
    let subtitle: String
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: UNPSpacing.md) {
            VStack(spacing: 0) {
                Circle()
                    .fill(UNPColor.emberGradient)
                    .frame(width: 10, height: 10)
                    .padding(.top, 5)
                if !isLast {
                    Rectangle()
                        .fill(UNPColor.ember.opacity(0.25))
                        .frame(width: 1.5)
                        .frame(minHeight: 40)
                }
            }
            .frame(width: 10)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(time)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.ember)
                    Spacer()
                }
                Text(title)
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(subtitle)
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
                    .lineLimit(1)
            }
            .padding(.bottom, isLast ? 0 : UNPSpacing.lg)
        }
    }
}
