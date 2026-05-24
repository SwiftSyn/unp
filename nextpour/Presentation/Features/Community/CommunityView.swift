import SwiftUI

struct CommunityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CommunityViewModel
    @State private var newMessageText = ""

    init() {
        _viewModel = State(initialValue: CommunityViewModel(
            fetchMessagesUseCase: DIContainer.shared.makeFetchCommunityMessagesUseCase()
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if viewModel.isLoading {
                    ScrollView {
                        VStack(spacing: UNPSpacing.sm) {
                            ForEach(0..<5, id: \.self) { _ in SkeletonRowView() }
                        }
                        .padding(UNPSpacing.md)
                    }
                } else if viewModel.messages.isEmpty {
                    ContentUnavailableView {
                        Label("No Messages Yet", systemImage: "bubble.left.and.bubble.right")
                    } description: {
                        Text("Be the first to start the conversation.")
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: UNPSpacing.sm) {
                            ForEach(viewModel.messages) { message in
                                MessageRow(message: message)
                            }
                        }
                        .padding(UNPSpacing.md)
                        .padding(.bottom, UNPSpacing.md)
                    }
                }
            }

            composeBar
        }
        .background(UNPColor.background)
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.copper)
                }
            }
        }
        .task { await viewModel.loadMessages() }
    }

    private var composeBar: some View {
        HStack(spacing: UNPSpacing.sm) {
            AvatarView(name: "You", imageURL: nil, size: 32)
            TextField("Say something…", text: $newMessageText)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
                .padding(.horizontal, UNPSpacing.sm)
                .padding(.vertical, UNPSpacing.xs)
                .background(UNPColor.surface)
                .clipShape(Capsule())
            Button {
                newMessageText = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(newMessageText.isEmpty ? UNPColor.textMuted : UNPColor.copper)
            }
            .disabled(newMessageText.isEmpty)
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
        .background(.ultraThinMaterial)
    }
}

private struct MessageRow: View {
    let message: CommunityMessage

    var body: some View {
        HStack(alignment: .top, spacing: UNPSpacing.md) {
            AvatarView(name: message.senderName, imageURL: message.senderAvatarURL, size: 38)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: UNPSpacing.xs) {
                    Text(message.senderName)
                        .font(UNPFontStyle.heading(14))
                        .foregroundStyle(UNPColor.copper)
                    Spacer()
                    Text(message.timestamp.formatted(.relative(presentation: .named)))
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                }
                Text(message.content)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                if let eventId = message.eventId {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 10))
                            .foregroundStyle(UNPColor.success)
                        Text("Event #\(eventId)")
                            .font(UNPFontStyle.label())
                            .foregroundStyle(UNPColor.success)
                    }
                }
            }
            .padding(UNPSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
        }
    }
}
