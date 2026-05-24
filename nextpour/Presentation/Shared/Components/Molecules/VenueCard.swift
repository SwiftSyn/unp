import SwiftUI

struct VenueCard: View {
    let venue: Venue

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: UNPRadius.medium)
                    .fill(UNPColor.surfaceElevated)
                    .frame(width: 56, height: 56)
                Image(systemName: "building.2.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(UNPColor.copper)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(venue.name)
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(UNPColor.textPrimary)
                    Spacer()
                    Circle()
                        .fill(venue.isOpen ? UNPColor.success : UNPColor.textMuted)
                        .frame(width: 8, height: 8)
                    Text(venue.isOpen ? "Open" : "Closed")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(venue.isOpen ? UNPColor.success : UNPColor.textMuted)
                }
                Text(venue.category)
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textSecondary)
                HStack(spacing: UNPSpacing.sm) {
                    StarRating(rating: venue.rating, starCount: 1, size: 12)
                    Text(String(format: "%.1f mi", venue.distanceMiles))
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpSurface()
    }
}
