import SwiftUI

struct AmbassadorView: View {
    @Environment(\.dismiss) private var dismiss

    private let ambassadors: [(name: String, location: String, specialty: String, rating: Double, badge: String)] = [
        ("Chef Andre", "Detroit, MI", "Classic Stirred Cocktails", 4.9, "crown.fill"),
        ("Maya Osei", "Detroit, MI", "Tropical & Tiki Builds", 4.8, "star.fill"),
        ("Jordan Ray", "Ann Arbor, MI", "Zero-Proof & Mocktails", 4.7, "leaf.fill"),
    ]

    var body: some View {
        ZStack {
            UNPColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    heroSection
                    ambassadorList
                    becomeSection
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
                Text("Ambassadors")
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.textPrimary)
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(
                    LinearGradient(
                        colors: [UNPColor.gold.opacity(0.25), UNPColor.surface],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(minHeight: 140)
                .overlay(
                    Image(systemName: "crown.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(UNPColor.gold.opacity(0.12))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(UNPSpacing.lg)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                        .stroke(UNPColor.gold.opacity(0.3), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                LabelChip(text: "UNP AMBASSADORS", icon: "crown.fill", color: UNPColor.gold)
                Text("Pour Leaders")
                    .font(UNPFontStyle.display(22))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Vetted bartenders and tastemakers shaping the scene.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            .padding(UNPSpacing.lg)
        }
    }

    private var ambassadorList: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Featured Ambassadors")

            VStack(spacing: UNPSpacing.sm) {
                ForEach(ambassadors, id: \.name) { ambassador in
                    ambassadorCard(ambassador)
                }
            }
        }
    }

    private func ambassadorCard(_ ambassador: (name: String, location: String, specialty: String, rating: Double, badge: String)) -> some View {
        HStack(spacing: UNPSpacing.md) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [UNPColor.gold.opacity(0.3), UNPColor.ember.opacity(0.2)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 52, height: 52)
                Text(String(ambassador.name.prefix(1)))
                    .font(UNPFontStyle.heading(20))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            .overlay(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .fill(UNPColor.gold)
                        .frame(width: 18, height: 18)
                    Image(systemName: ambassador.badge)
                        .font(.system(size: 9))
                        .foregroundStyle(.black)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(ambassador.name)
                    .font(UNPFontStyle.heading(15))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(ambassador.specialty)
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textSecondary)
                Text(ambassador.location)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                StarRating(rating: ambassador.rating, starCount: 1, size: 12)
                Text(String(format: "%.1f", ambassador.rating))
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.ember)
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private var becomeSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            SectionHeader(title: "Become an Ambassador")

            VStack(spacing: UNPSpacing.sm) {
                requirementRow("wineglass.fill", "3+ months active on UNP", UNPColor.ember)
                requirementRow("star.fill", "4.5+ community rating", UNPColor.gold)
                requirementRow("person.2.fill", "Part of 2+ Pour Circles", UNPColor.azure)
                requirementRow("checkmark.seal.fill", "Verified bartender or tastemaker", UNPColor.neon)
            }
            .padding(UNPSpacing.md)
            .unpCard()

            Button {} label: {
                Text("Apply to Become Ambassador")
                    .font(UNPFontStyle.heading(15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UNPSpacing.md)
                    .background(UNPColor.emberGradient)
                    .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            }
            .buttonStyle(.plain)
        }
    }

    private func requirementRow(_ icon: String, _ text: String, _ color: Color) -> some View {
        HStack(spacing: UNPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 20)
            Text(text)
                .font(UNPFontStyle.body(14))
                .foregroundStyle(UNPColor.textSecondary)
        }
    }
}
