import SwiftUI

extension View {
    func unpCard(background: Color = UNPColor.surface, radius: CGFloat = UNPRadius.large) -> some View {
        self
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    func unpSurface(radius: CGFloat = UNPRadius.large) -> some View {
        self
            .background(UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .unpShadow(UNPShadow.card)
    }

    func unpGlassCard(radius: CGFloat = UNPRadius.large) -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    func sectionLabel(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text(text)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.8)
            self
        }
    }
}

struct ChevronRight: View {
    var color: Color = UNPColor.textMuted

    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(color)
    }
}

struct SectionHeader: View {
    let title: String
    var action: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(UNPFontStyle.heading())
                .foregroundStyle(UNPColor.textPrimary)
            Spacer()
            if let action, let onAction {
                Button(action: onAction) {
                    Text(action)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.copper)
                }
            }
        }
    }
}

struct LabelChip: View {
    let text: String
    var icon: String? = nil
    var color: Color = UNPColor.copper
    var filled: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
            }
            Text(text)
                .font(UNPFontStyle.label())
        }
        .foregroundStyle(filled ? .black : color)
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, 5)
        .background(filled ? color : color.opacity(0.15))
        .clipShape(Capsule())
    }
}

struct NavRow: View {
    let icon: String
    let label: String
    var detail: String? = nil
    var color: Color = UNPColor.copper
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UNPSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(color)
                    .frame(width: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textPrimary)
                    if let detail {
                        Text(detail)
                            .font(UNPFontStyle.caption(12))
                            .foregroundStyle(UNPColor.textMuted)
                    }
                }
                Spacer()
                ChevronRight()
            }
            .padding(UNPSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
