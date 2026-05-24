import SwiftUI

struct StarRating: View {
    let rating: Double
    var starCount: Int = 5
    var size: CGFloat = 14

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<starCount, id: \.self) { index in
                Image(systemName: starName(for: index))
                    .font(.system(size: size))
                    .foregroundStyle(UNPColor.gold)
            }
            Text(String(format: "%.1f", rating))
                .font(UNPFontStyle.label(size))
                .foregroundStyle(UNPColor.textSecondary)
        }
    }

    private func starName(for index: Int) -> String {
        let threshold = Double(index) + 1
        if rating >= threshold { return "star.fill" }
        if rating >= threshold - 0.5 { return "star.leadinghalf.filled" }
        return "star"
    }
}
