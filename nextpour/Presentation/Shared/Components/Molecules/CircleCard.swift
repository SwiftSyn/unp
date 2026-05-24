import SwiftUI

struct CircleCard: View {
    let circle: PourCircle
    var onJoin: () -> Void = {}

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            ZStack {
                SwiftUI.Circle()
                    .fill(UNPColor.violet.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "person.3.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(UNPColor.violet)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(circle.name)
                    .font(UNPFontStyle.heading(15))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(circle.description)
                    .font(UNPFontStyle.body(13))
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(1)
                Text("\(circle.memberCount) members")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
            }

            Spacer()

            Button(action: onJoin) {
                Text(circle.isMember ? "Leave" : "Join")
                    .font(UNPFontStyle.label(12))
                    .foregroundStyle(circle.isMember ? UNPColor.textSecondary : UNPColor.copper)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(circle.isMember ? UNPColor.surface : UNPColor.copper.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(UNPSpacing.md)
        .unpSurface()
    }
}
