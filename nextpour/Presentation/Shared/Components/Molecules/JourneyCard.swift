import SwiftUI

struct JourneyCard: View {
    let icon: String
    let label: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(color)
                }
                Spacer()
                Text(label)
                    .font(UNPFontStyle.heading(13))
                    .foregroundStyle(UNPColor.textPrimary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                    .lineLimit(1)
            }
            .padding(UNPSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
            .background(UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
        }
        .buttonStyle(.plain)
    }
}
