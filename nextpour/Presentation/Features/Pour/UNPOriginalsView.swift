import SwiftUI

struct OriginalsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showSubscribe = false

    private let classes: [(String, String, String, Bool)] = [
        ("Sunrise Yoga Mixology", "Sun, April 19 · 6:00 AM · South Lake Tahoe, CA", "figure.mind.and.body", false),
        ("Advanced Techniques", "Tue, April 21 · Detroit, MI", "graduationcap.fill", false),
        ("Barrel Aging Masterclass", "Sat, April 26 · Chicago, IL", "cylinder.fill", true),
        ("Cocktail Photography", "Fri, May 2 · Detroit, MI", "camera.fill", true)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.lg) {
                heroSection
                classesSection
                subscribeCard
            }
            .padding(UNPSpacing.md)
        }
        .background(UNPColor.background)
        .navigationBarBackButtonHidden()
        .navigationTitle("UNP Originals")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.copper)
                }
            }
        }
        .sheet(isPresented: $showSubscribe) {
            SubscribeSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(
                    LinearGradient(
                        colors: [UNPColor.violetLight.opacity(0.2), UNPColor.surface],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(height: 140)
                .overlay(
                    RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                        .stroke(UNPColor.violet.opacity(0.2), lineWidth: 1)
                )

            Image(systemName: "play.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(UNPColor.violet.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .padding(UNPSpacing.lg)

            VStack(alignment: .leading, spacing: 4) {
                LabelChip(text: "CURATED CONTENT", icon: "star.fill", color: UNPColor.violet)
                Text("Get the party started with Classes")
                    .font(UNPFontStyle.heading(18))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            .padding(UNPSpacing.lg)
        }
    }

    private var classesSection: some View {
        VStack(spacing: UNPSpacing.sm) {
            ForEach(classes, id: \.0) { item in
                ClassRow(
                    title: item.0,
                    subtitle: item.1,
                    icon: item.2,
                    isLocked: item.3,
                    action: { if item.3 { showSubscribe = true } }
                )
            }
        }
    }

    private var subscribeCard: some View {
        VStack(spacing: UNPSpacing.md) {
            Image(systemName: "lock.open.fill")
                .font(.system(size: 32))
                .foregroundStyle(UNPColor.violet)
            Text("Unlock All Classes")
                .font(UNPFontStyle.heading())
                .foregroundStyle(UNPColor.textPrimary)
            Text("An UNP Premium subscription is required to unlock all classes and exclusive content.")
                .font(UNPFontStyle.body(14))
                .foregroundStyle(UNPColor.textSecondary)
                .multilineTextAlignment(.center)
            Button { showSubscribe = true } label: {
                Text("Subscribe · $9.99/month")
                    .font(UNPFontStyle.heading(15))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(UNPColor.cream)
                    .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
            }
        }
        .padding(UNPSpacing.lg)
        .unpCard()
    }
}

private struct ClassRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UNPSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: UNPRadius.small)
                        .fill(UNPColor.violet.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(UNPColor.violet)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(UNPFontStyle.heading(14))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text(subtitle)
                        .font(UNPFontStyle.caption(12))
                        .foregroundStyle(UNPColor.textMuted)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: isLocked ? "lock.fill" : "chevron.right")
                    .font(.system(size: 13))
                    .foregroundStyle(isLocked ? UNPColor.textMuted : UNPColor.copper)
            }
            .padding(UNPSpacing.md)
            .unpCard()
        }
        .buttonStyle(.plain)
    }
}

private struct SubscribeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoadingMonthly = false
    @State private var isLoadingAnnual = false

    var body: some View {
        VStack(spacing: UNPSpacing.lg) {
            DrawerHandle()
            ZStack {
                Circle()
                    .fill(UNPColor.violet.opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(UNPColor.violet)
            }
            VStack(spacing: UNPSpacing.xs) {
                Text("UNP Premium")
                    .font(UNPFontStyle.display(24))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Unlock all classes, exclusive recipes, and Pour Circle features.")
                    .font(UNPFontStyle.body())
                    .foregroundStyle(UNPColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            VStack(spacing: UNPSpacing.sm) {
                Button {
                    isLoadingMonthly = true
                    Task {
                        try? await Task.sleep(for: .seconds(0.8))
                        isLoadingMonthly = false
                        dismiss()
                    }
                } label: {
                    Group {
                        if isLoadingMonthly {
                            LoadingSpinner(color: .black, size: 18)
                        } else {
                            Text("Monthly · $9.99")
                                .font(UNPFontStyle.heading(15))
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(UNPColor.copper)
                    .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                }
                .disabled(isLoadingMonthly || isLoadingAnnual)
                Button {
                    isLoadingAnnual = true
                    Task {
                        try? await Task.sleep(for: .seconds(0.8))
                        isLoadingAnnual = false
                        dismiss()
                    }
                } label: {
                    Group {
                        if isLoadingAnnual {
                            LoadingSpinner(color: UNPColor.copper, size: 18)
                        } else {
                            HStack {
                                Text("Annually · $89.99")
                                LabelChip(text: "Save 25%", color: UNPColor.success)
                            }
                            .font(UNPFontStyle.heading(15))
                            .foregroundStyle(UNPColor.copper)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(UNPColor.copper.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                }
                .disabled(isLoadingMonthly || isLoadingAnnual)
            }
            .padding(.horizontal)
            Button("Not now") { dismiss() }
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textMuted)
        }
        .padding(.bottom, UNPSpacing.xl)
    }
}
