import SwiftUI

enum UserMood: String, CaseIterable, Identifiable {
    case happy, relaxed, energetic, romantic, celebratory, sophisticated

    var id: String { rawValue }
    var label: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .relaxed: return "figure.mind.and.body"
        case .energetic: return "bolt.fill"
        case .romantic: return "heart.fill"
        case .celebratory: return "party.popper.fill"
        case .sophisticated: return "crown.fill"
        }
    }
    var subtitle: String {
        switch self {
        case .happy: return "Feeling joyful and upbeat"
        case .relaxed: return "Want to unwind and chat"
        case .energetic: return "Ready to party and have fun"
        case .romantic: return "Looking for something intimate"
        case .celebratory: return "It's a special occasion"
        case .sophisticated: return "Elevated vibes only"
        }
    }
}

struct MoodSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMoods: Set<UserMood>
    let onContinue: (Set<UserMood>) -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            DrawerHandle()

            VStack(alignment: .leading, spacing: UNPSpacing.lg) {
                VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                    Text("How are you feeling?")
                        .font(UNPFontStyle.display(22))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text("Select the moods that match how you're feeling right now.")
                        .font(UNPFontStyle.body(14))
                        .foregroundStyle(UNPColor.textSecondary)
                }
                .padding(.top, UNPSpacing.md)

                LazyVGrid(columns: columns, spacing: UNPSpacing.sm) {
                    ForEach(UserMood.allCases) { mood in
                        MoodTile(
                            mood: mood,
                            isSelected: selectedMoods.contains(mood),
                            onTap: {
                                if selectedMoods.contains(mood) {
                                    selectedMoods.remove(mood)
                                } else {
                                    selectedMoods.insert(mood)
                                }
                            }
                        )
                    }
                }

                HStack {
                    Text("\(selectedMoods.count) Selected")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textMuted)
                    Spacer()
                    Button {
                        onContinue(selectedMoods)
                        dismiss()
                    } label: {
                        Text("Continue")
                            .font(UNPFontStyle.heading(15))
                            .foregroundStyle(.black)
                            .padding(.horizontal, UNPSpacing.xl)
                            .padding(.vertical, UNPSpacing.sm)
                            .background(selectedMoods.isEmpty ? UNPColor.textMuted : UNPColor.copper)
                            .clipShape(Capsule())
                    }
                    .disabled(selectedMoods.isEmpty)
                }
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.bottom, UNPSpacing.xl)
        }
        .background(UNPColor.background)
    }
}

private struct MoodTile: View {
    let mood: UserMood
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: UNPSpacing.sm) {
                Image(systemName: mood.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                VStack(spacing: 2) {
                    Text(mood.label)
                        .font(UNPFontStyle.heading(13))
                        .foregroundStyle(isSelected ? .black : UNPColor.textPrimary)
                    Text(mood.subtitle)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(isSelected ? .black.opacity(0.6) : UNPColor.textMuted)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(UNPSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(isSelected ? UNPColor.violet : UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            .animation(.spring(response: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
