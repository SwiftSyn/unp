import SwiftUI

struct BeverageCard: View {
    let beverage: Beverage
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: UNPRadius.medium)
                        .fill(UNPColor.surfaceElevated)
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "wineglass.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(UNPColor.copper.opacity(0.4))
                        )
                    if beverage.isAmbassadorUpload {
                        TagBadge(text: "Ambassador", color: UNPColor.violet)
                            .padding(UNPSpacing.sm)
                    }
                }

                Text(beverage.name)
                    .font(UNPFontStyle.heading(15))
                    .foregroundStyle(UNPColor.textPrimary)
                    .lineLimit(1)

                HStack {
                    TagBadge(text: beverage.category.displayName)
                    Spacer()
                    StarRating(rating: beverage.rating, starCount: 1, size: 12)
                }
            }
            .padding(UNPSpacing.sm)
            .unpCard()
        }
        .buttonStyle(.plain)
    }
}
