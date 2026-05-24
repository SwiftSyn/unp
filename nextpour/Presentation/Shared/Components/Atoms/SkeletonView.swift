import SwiftUI

struct SkeletonView: View {
    let width: CGFloat?
    let height: CGFloat
    let radius: CGFloat

    @State private var phase: CGFloat = 0

    init(width: CGFloat? = nil, height: CGFloat = 16, radius: CGFloat = UNPRadius.medium) {
        self.width = width
        self.height = height
        self.radius = radius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(shimmerGradient)
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }

    private var shimmerGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: UNPColor.surface, location: phase - 0.3),
                .init(color: UNPColor.surfaceElevated, location: phase),
                .init(color: UNPColor.surface, location: phase + 0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct SkeletonCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SkeletonView(height: 140, radius: UNPRadius.large)
            SkeletonView(width: 180, height: 14)
            SkeletonView(width: 120, height: 11)
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}

struct SkeletonRowView: View {
    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            SkeletonView(width: 48, height: 48, radius: UNPRadius.pill)
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                SkeletonView(width: 140, height: 13)
                SkeletonView(width: 90, height: 11)
            }
            Spacer()
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}
