import SwiftUI

struct RatingView: View {
    @Environment(\.dismiss) private var dismiss

    private let reviews: [(author: String, rating: Double, comment: String, date: String)] = [
        ("Maya O.", 5.0, "Incredible taste, always knows exactly what to recommend for the vibe.", "Mar 2025"),
        ("Jordan R.", 4.8, "Solid suggestions every time. The Old Fashioned pick was perfect.", "Feb 2025"),
        ("Chef Andre", 4.9, "Great palate and even better energy. A true pour enthusiast.", "Jan 2025"),
    ]

    private let breakdown: [(stars: Int, count: Int)] = [
        (5, 28), (4, 9), (3, 2), (2, 0), (1, 0)
    ]

    private var totalRatings: Int { breakdown.reduce(0) { $0 + $1.count } }
    private var overallRating: Double { 4.8 }

    var body: some View {
        ZStack {
            UNPColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    summaryCard
                    breakdownCard
                    reviewsList
                    Spacer().frame(height: UNPSpacing.xxl)
                }
                .padding(.horizontal, UNPSpacing.md)
                .padding(.top, UNPSpacing.sm)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("My Rating")
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.textPrimary)
            }
        }
    }

    private var summaryCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(
                    LinearGradient(
                        colors: [UNPColor.error.opacity(0.2), UNPColor.surface],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(minHeight: 140)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(UNPColor.error.opacity(0.1))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(UNPSpacing.lg)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                        .stroke(UNPColor.error.opacity(0.25), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                LabelChip(text: "COMMUNITY RATING", icon: "heart.fill", color: UNPColor.error)
                HStack(alignment: .firstTextBaseline, spacing: UNPSpacing.xs) {
                    Text(String(format: "%.1f", overallRating))
                        .font(UNPFontStyle.display(36))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text("/ 5.0")
                        .font(UNPFontStyle.body(14))
                        .foregroundStyle(UNPColor.textMuted)
                }
                HStack(spacing: UNPSpacing.xs) {
                    StarRating(rating: overallRating, starCount: 5, size: 14)
                    Text("(\(totalRatings) reviews)")
                        .font(UNPFontStyle.caption(12))
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
            .padding(UNPSpacing.lg)
        }
    }

    private var breakdownCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            SectionHeader(title: "Rating Breakdown")

            VStack(spacing: UNPSpacing.sm) {
                ForEach(breakdown, id: \.stars) { row in
                    HStack(spacing: UNPSpacing.sm) {
                        Text("\(row.stars)")
                            .font(UNPFontStyle.caption(12))
                            .foregroundStyle(UNPColor.textMuted)
                            .frame(width: 10)
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(UNPColor.gold)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(UNPColor.surface)
                                    .frame(height: 6)
                                Capsule()
                                    .fill(UNPColor.emberGradient)
                                    .frame(width: totalRatings > 0 ? geo.size.width * CGFloat(row.count) / CGFloat(totalRatings) : 0, height: 6)
                            }
                        }
                        .frame(height: 6)

                        Text("\(row.count)")
                            .font(UNPFontStyle.caption(12))
                            .foregroundStyle(UNPColor.textMuted)
                            .frame(width: 24, alignment: .trailing)
                    }
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private var reviewsList: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Recent Reviews")

            VStack(spacing: UNPSpacing.sm) {
                ForEach(reviews, id: \.author) { review in
                    reviewCard(review)
                }
            }
        }
    }

    private func reviewCard(_ review: (author: String, rating: Double, comment: String, date: String)) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                AvatarView(name: review.author, imageURL: nil, size: 34)
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author)
                        .font(UNPFontStyle.heading(14))
                        .foregroundStyle(UNPColor.textPrimary)
                    StarRating(rating: review.rating, starCount: 5, size: 11)
                }
                Spacer()
                Text(review.date)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
            }
            Text(review.comment)
                .font(UNPFontStyle.body(14))
                .foregroundStyle(UNPColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}
