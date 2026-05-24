import SwiftUI

struct SettingsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var locationServices = true
    @State private var showNotifications = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.lg) {
                accountSection
                preferencesSection
                supportSection
            }
            .padding(UNPSpacing.lg)
        }
        .background(UNPColor.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
        }
        .navigationDestination(isPresented: $showNotifications) {
            NotificationsSettingsView()
        }
    }

    private var accountSection: some View {
        settingsGroup(header: "Account") {
            NavRow(icon: "creditcard.fill", label: "Payment Methods") {}
            NavRow(icon: "location.fill", label: "Saved Addresses") {}
            NavRow(icon: "bell.fill", label: "Notifications") {
                showNotifications = true
            }
        }
    }

    private var preferencesSection: some View {
        settingsGroup(header: "Preferences") {
            HStack(spacing: UNPSpacing.md) {
                Image(systemName: "location.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(UNPColor.ember)
                    .frame(width: 26)
                Text("Location Services")
                    .font(UNPFontStyle.body())
                    .foregroundStyle(UNPColor.textPrimary)
                Spacer()
                Toggle("", isOn: $locationServices)
                    .tint(UNPColor.neon)
                    .labelsHidden()
            }
            .padding(UNPSpacing.md)
            NavRow(icon: "paintbrush.fill", label: "Appearance") {}
            NavRow(icon: "globe", label: "Language") {}
        }
    }

    private var supportSection: some View {
        settingsGroup(header: "Support") {
            NavRow(icon: "questionmark.circle.fill", label: "Help & Support") {}
            NavRow(icon: "bubble.left.and.bubble.right.fill", label: "Live Chat") {}
            NavRow(icon: "envelope.fill", label: "Email Us") {}
        }
    }

    private func settingsGroup<Content: View>(header: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text(header)
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .padding(.horizontal, 4)
            VStack(spacing: 0) {
                content()
            }
            .unpCard()
        }
    }
}
