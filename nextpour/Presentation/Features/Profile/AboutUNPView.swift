import SwiftUI

struct AboutUNPView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showHelpSupport = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    brandSection
                    descriptionCard
                    helpSupportButton
                    rateButton
                }
                .padding(UNPSpacing.lg)
            }
            .background(UNPColor.background)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundStyle(UNPColor.copper)
                }
            }
            .navigationDestination(isPresented: $showHelpSupport) {
                HelpSupportView()
            }
        }
    }

    private var brandSection: some View {
        VStack(spacing: UNPSpacing.sm) {
            Image("UNPLoginMark")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            Text("Until The Next Pour")
                .font(UNPFontStyle.display(22))
                .foregroundStyle(UNPColor.textPrimary)
            Text("Version 1.0.0")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textMuted)
        }
        .padding(.top, UNPSpacing.md)
    }

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("About Until The Next Pour")
                .font(UNPFontStyle.heading())
                .foregroundStyle(UNPColor.textPrimary)
            Text("Until The Next Pour is your guide to the Detroit night scene. Discover curated cocktails, connect with bartenders, find live events, and plan your night with your Pour Circle.")
                .font(UNPFontStyle.body(14))
                .foregroundStyle(UNPColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(UNPSpacing.md)
        .frame(maxWidth: .infinity)
        .unpCard()
    }

    private var helpSupportButton: some View {
        NavRow(icon: "questionmark.circle.fill", label: "Help & Support") {
            showHelpSupport = true
        }
        .unpCard()
    }

    private var rateButton: some View {
        NavRow(icon: "star.fill", label: "Rate Us on App Store", color: UNPColor.gold) {}
            .unpCard()
    }
}

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss

    private let faqs = [
        ("How do I discover beverages?", "Browse The Pour journey to explore and save cocktails curated for your city."),
        ("How do I find events near me?", "Open The Explore journey to see events and venues on the map or list view."),
        ("How do I join a Pour Circle?", "Go to Pour Circle tab, browse available circles, and tap Join to become a member."),
        ("How do I contact support?", "Reach us via email or live chat using the options below.")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.md) {
                faqSection
                contactSection
            }
            .padding(UNPSpacing.lg)
        }
        .background(UNPColor.background)
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }.foregroundStyle(UNPColor.copper)
            }
        }
    }

    private var faqSection: some View {
        VStack(spacing: UNPSpacing.sm) {
            ForEach(faqs, id: \.0) { faq in
                FAQRow(question: faq.0, answer: faq.1)
            }
        }
    }

    private var contactSection: some View {
        VStack(spacing: UNPSpacing.sm) {
            NavRow(icon: "envelope.fill", label: "Email Support", detail: "support@siprymc.com") {}
                .unpCard()
            NavRow(icon: "phone.fill", label: "Phone Support", detail: "1-800-SIP-SYNC") {}
                .unpCard()
            NavRow(icon: "bubble.left.fill", label: "Live Chat", detail: "Available 9am–9pm EST") {}
                .unpCard()
        }
    }
}

private struct FAQRow: View {
    let question: String
    let answer: String
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: expanded ? UNPSpacing.sm : 0) {
            Button {
                withAnimation(.spring(response: 0.3)) { expanded.toggle() }
            } label: {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(UNPColor.copper.opacity(0.7))
                    Text(question)
                        .font(UNPFontStyle.body(14))
                        .foregroundStyle(UNPColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(UNPColor.textMuted)
                }
            }
            .buttonStyle(.plain)
            .padding(UNPSpacing.md)

            if expanded {
                Text(answer)
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.md)
            }
        }
        .unpCard()
    }
}
