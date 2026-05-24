import SwiftUI

struct TagBadge: View {
    let text: String
    var color: Color = UNPColor.copper
    var size: CGFloat = 12

    var body: some View {
        Text(text)
            .font(UNPFontStyle.label(size))
            .foregroundStyle(color)
            .padding(.horizontal, UNPSpacing.sm)
            .padding(.vertical, UNPSpacing.xs)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}
