import SwiftUI

struct SuccessStateView: View {
    let title: String
    let message: String
    var onDone: (() -> Void)?

    var body: some View {
        VStack(spacing: UNPSpacing.lg) {
            ZStack {
                Circle()
                    .fill(UNPColor.success.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(UNPColor.success)
            }
            VStack(spacing: UNPSpacing.xs) {
                Text(title)
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Text(message)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let onDone {
                Button(action: onDone) {
                    Text("Done")
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(.black)
                        .padding(.horizontal, UNPSpacing.xl)
                        .padding(.vertical, UNPSpacing.sm)
                        .background(UNPColor.copper)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(UNPSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}
