import SwiftUI

struct AuraActivityHistoryView: View {
    let reward: Reward
    @Environment(AppTheme.self) private var theme
    @Environment(\.dismiss) private var dismiss

    // Allocated once, not on every render
    private static let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f
    }()

    private var totalEarned: Int {
        reward.history.reduce(0) { $0 + $1.points }
    }

    private var groupedHistory: [(month: String, transactions: [RewardTransaction])] {
        let grouped = Dictionary(
            grouping: reward.history.sorted { $0.date > $1.date },
            by: { Self.monthFormatter.string(from: $0.date) }
        )
        return grouped
            .map { (month: $0.key, transactions: $0.value) }
            .sorted {
                let l = Self.monthFormatter.date(from: $0.month) ?? .distantPast
                let r = Self.monthFormatter.date(from: $1.month) ?? .distantPast
                return l > r
            }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()
                Group {
                    if reward.history.isEmpty {
                        emptyState
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: UNPSpacing.lg) {
                                summaryHeader
                                historyList
                            }
                            .padding(.horizontal, UNPSpacing.md)
                            .padding(.bottom, UNPSpacing.xxl)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { historyToolbar }
        }
    }

    // MARK: - Toolbar
    private var historyToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(UNPColor.azure)
                    Text("Activity History")
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

    // MARK: - Summary header
    private var summaryHeader: some View {
        HStack(spacing: UNPSpacing.md) {
            statCell(value: "\(reward.points)", label: "Balance",      icon: "sparkles",              color: UNPColor.ember)
            Divider().frame(height: 40)
            statCell(value: "\(totalEarned)",   label: "Total Earned", icon: "arrow.up.circle.fill",  color: UNPColor.azure)
            Divider().frame(height: 40)
            statCell(value: "\(reward.history.count)", label: "Activities", icon: "list.bullet.circle.fill", color: UNPColor.neon)
        }
        .padding(UNPSpacing.md)
        .unpCard()
        .padding(.top, UNPSpacing.sm)
    }

    private func statCell(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: UNPSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(UNPColor.textPrimary)
            Text(label)
                .font(UNPFontStyle.label(10))
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.8)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - History list
    private var historyList: some View {
        VStack(spacing: UNPSpacing.md) {
            ForEach(groupedHistory, id: \.month) { group in
                monthSection(group.month, transactions: group.transactions)
            }
        }
    }

    private func monthSection(_ month: String, transactions: [RewardTransaction]) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text(month)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                    .textCase(.uppercase)
                    .tracking(0.8)
                Spacer()
                Text("+\(transactions.reduce(0) { $0 + $1.points }) pts")
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.azure)
            }
            .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { index, tx in
                    transactionRow(tx)
                    if index < transactions.count - 1 {
                        Divider()
                            .background(UNPColor.surfaceElevated)
                            .padding(.leading, 56)
                    }
                }
            }
            .unpCard()
        }
    }

    private func transactionRow(_ tx: RewardTransaction) -> some View {
        HStack(spacing: UNPSpacing.md) {
            IconBadge(
                systemName: icon(for: tx),
                color: UNPColor.azure,
                size: 38,
                backgroundColor: UNPColor.azure.opacity(0.12)
            )
            VStack(alignment: .leading, spacing: 3) {
                Text(tx.description)
                    .font(UNPFontStyle.body())
                    .foregroundStyle(UNPColor.textPrimary)
                Text(tx.date.formatted(date: .abbreviated, time: .omitted))
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
            }
            Spacer()
            Text("+\(tx.points)")
                .font(UNPFontStyle.heading(15))
                .foregroundStyle(UNPColor.azure)
        }
        .padding(UNPSpacing.md)
    }

    private func icon(for tx: RewardTransaction) -> String {
        let d = tx.description.lowercased()
        if d.contains("recipe") || d.contains("save")              { return "bookmark.fill" }
        if d.contains("event")                                      { return "calendar.badge.checkmark" }
        if d.contains("share") || d.contains("link")               { return "square.and.arrow.up" }
        if d.contains("circle")                                     { return "person.3.fill" }
        if d.contains("class") || d.contains("host")               { return "person.badge.star.fill" }
        if d.contains("journey") || d.contains("plan")             { return "checkmark.seal.fill" }
        if d.contains("review")                                     { return "star.bubble.fill" }
        if d.contains("referral") || d.contains("refer")           { return "person.badge.plus" }
        if d.contains("venue") || d.contains("check")              { return "building.2.fill" }
        if d.contains("community") || d.contains("post")           { return "bubble.left.fill" }
        if d.contains("bonus") || d.contains("streak")             { return "star.fill" }
        return "bolt.fill"
    }

    // MARK: - Empty state
    private var emptyState: some View {
        VStack(spacing: UNPSpacing.lg) {
            Image(systemName: "bolt.slash.fill")
                .font(.system(size: 48))
                .foregroundStyle(UNPColor.textMuted)
            VStack(spacing: UNPSpacing.xs) {
                Text("No activity yet")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Start engaging with venues and events to earn your first Aura points.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(UNPSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
