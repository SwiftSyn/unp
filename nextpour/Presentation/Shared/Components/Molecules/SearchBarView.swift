import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search..."

    var body: some View {
        HStack(spacing: UNPSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(UNPColor.textSecondary)
            TextField(placeholder, text: $text)
                .foregroundStyle(UNPColor.textPrimary)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
        }
        .padding(UNPSpacing.sm)
        .background(UNPColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
    }
}
