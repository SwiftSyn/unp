import SwiftUI

struct ToggleChipGroup<T: Hashable>: View {
    let options: [T]
    @Binding var selection: T
    let label: (T) -> String
    var accentColor: Color = UNPColor.copper

    var body: some View {
        HStack(spacing: UNPSpacing.xs) {
            ForEach(options, id: \.self) { option in
                ToggleChip(
                    title: label(option),
                    isSelected: selection == option,
                    action: { selection = option },
                    accentColor: accentColor
                )
            }
        }
    }
}

struct ToggleChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var accentColor: Color = UNPColor.copper

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(UNPFontStyle.caption())
                .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
                .background(isSelected ? accentColor : UNPColor.surface)
                .clipShape(Capsule())
                .animation(.spring(response: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
