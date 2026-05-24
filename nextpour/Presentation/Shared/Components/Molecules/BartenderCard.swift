import SwiftUI

struct BartenderCard: View {
    let bartender: Bartender

    var body: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack(spacing: UNPSpacing.sm) {
                AvatarView(name: bartender.name, size: 44)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(bartender.name)
                            .font(UNPFontStyle.heading(14))
                            .foregroundStyle(UNPColor.textPrimary)
                        if bartender.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(UNPColor.violet)
                        }
                    }
                    Text("\(bartender.yearsExperience) yrs experience")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textSecondary)
                }
                Spacer()
                StarRating(rating: bartender.rating, starCount: 1, size: 13)
            }

            Text(bartender.bio)
                .font(UNPFontStyle.body(13))
                .foregroundStyle(UNPColor.textSecondary)
                .lineLimit(2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.xs) {
                    ForEach(bartender.specialties, id: \.self) { specialty in
                        TagBadge(text: specialty, size: 11)
                    }
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpSurface()
    }
}
