import SwiftUI

struct EventCard: View {
    let event: Event
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: UNPSpacing.md) {
                VStack(spacing: 4) {
                    Text(event.date.formatted(as: "d"))
                        .font(UNPFontStyle.display(22))
                        .foregroundStyle(UNPColor.copper)
                    Text(event.date.formatted(as: "MMM").uppercased())
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textSecondary)
                }
                .frame(width: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(UNPColor.textPrimary)
                        .lineLimit(2)
                    Text(event.venueName)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textSecondary)
                    HStack(spacing: UNPSpacing.sm) {
                        TagBadge(text: event.category.displayName)
                        Text("\(event.attendeeCount) going")
                            .font(UNPFontStyle.label())
                            .foregroundStyle(UNPColor.textMuted)
                    }
                }
                Spacer()
                ChevronRight()
            }
            .padding(UNPSpacing.md)
            .unpSurface()
        }
        .buttonStyle(.plain)
    }
}
