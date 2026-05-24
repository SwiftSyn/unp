import SwiftUI

struct ProfileHeaderCard: View {
    let name: String
    let location: String
    let imageURL: String?
    var onEditPhoto: (() -> Void)?

    var body: some View {
        VStack(spacing: UNPSpacing.sm) {
            ZStack(alignment: .bottomTrailing) {
                AvatarView(name: name, imageURL: imageURL, size: 88)
                if onEditPhoto != nil {
                    Button(action: { onEditPhoto?() }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(7)
                            .background(UNPColor.copper)
                            .clipShape(Circle())
                    }
                    .offset(x: 4, y: 4)
                }
            }
            Text(name)
                .font(UNPFontStyle.display(20))
                .foregroundStyle(UNPColor.textPrimary)
            if !location.isEmpty {
                Label(location, systemImage: "location.fill")
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textSecondary)
            }
        }
    }
}

struct StatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(UNPFontStyle.heading(17))
                .foregroundStyle(UNPColor.textPrimary)
            Text(label)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}
