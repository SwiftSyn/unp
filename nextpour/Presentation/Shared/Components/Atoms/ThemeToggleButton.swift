import SwiftUI

struct ThemeToggleButton: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        Button { theme.toggle() } label: {
            Image(systemName: theme.toggleIcon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.toggleColor)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
