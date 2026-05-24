import SwiftUI

struct PostCard: View {
    let post: Post
    var onLike: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            HStack(spacing: UNPSpacing.sm) {
                AvatarView(name: post.authorName, size: 38)
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textPrimary)
                    Text(post.timestamp.relativeDescription)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textSecondary)
                }
                Spacer()
                if let tag = post.drinkTag {
                    TagBadge(text: tag)
                }
            }

            Text(post.content)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
                .lineLimit(4)

            HStack(spacing: UNPSpacing.lg) {
                Button(action: onLike) {
                    Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(post.isLiked ? UNPColor.error : UNPColor.textSecondary)
                }
                Label("\(post.commentCount)", systemImage: "bubble.right")
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textSecondary)
                Spacer()
            }
        }
        .padding(UNPSpacing.md)
        .unpSurface()
    }
}
