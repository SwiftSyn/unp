import SwiftUI

struct IconBadge: View {
    let systemName: String
    var color: Color = UNPColor.copper
    var size: CGFloat = 20
    var backgroundColor: Color = UNPColor.copper.opacity(0.15)

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.6, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
    }
}
