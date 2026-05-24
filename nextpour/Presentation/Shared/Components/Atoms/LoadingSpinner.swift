import SwiftUI

struct LoadingSpinner: View {
    var color: Color = UNPColor.copper
    var size: CGFloat = 24

    var body: some View {
        ProgressView()
            .tint(color)
            .scaleEffect(size / 24)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: UNPSpacing.md) {
            LoadingSpinner(size: 36)
            Text("Loading...")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
