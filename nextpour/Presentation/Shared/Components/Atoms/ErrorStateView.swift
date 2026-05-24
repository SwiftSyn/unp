import SwiftUI

struct ErrorStateView: View {
    let message: String
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: UNPSpacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(UNPColor.error)
            VStack(spacing: UNPSpacing.xs) {
                Text("Something went wrong")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Text(message)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let onRetry {
                Button(action: onRetry) {
                    Text("Try Again")
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
