import SwiftUI

struct AvatarView: View {
    let name: String
    var imageURL: String? = nil
    var size: CGFloat = 40

    var body: some View {
        Group {
            if let url = imageURL, !url.isEmpty {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    initialsView
                }
            } else {
                initialsView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var initialsView: some View {
        ZStack {
            Circle().fill(UNPColor.copper.opacity(0.25))
            Text(initials)
                .font(UNPFontStyle.label(size * 0.35))
                .foregroundStyle(UNPColor.copper)
        }
    }

    private var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }
}
