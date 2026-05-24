import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: Style = .filled

    enum Style { case filled, outlined, ghost }

    var body: some View {
        Button(action: action) {
            HStack(spacing: UNPSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(style == .filled ? .black : UNPColor.copper)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: UNPRadius.medium)
                    .stroke(borderColor, lineWidth: style == .outlined ? 1.5 : 0)
            )
        }
        .disabled(isLoading)
    }

    private var backgroundColor: Color {
        switch style {
        case .filled: return UNPColor.copper
        case .outlined, .ghost: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .filled: return .black
        case .outlined, .ghost: return UNPColor.copper
        }
    }

    private var borderColor: Color {
        style == .outlined ? UNPColor.copper : .clear
    }
}
