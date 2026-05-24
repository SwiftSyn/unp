import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pushEnabled = true
    @State private var emailEnabled = true
    @State private var eventReminders = false
    @State private var communityUpdates = true
    @State private var ambassadorAlerts = true

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.md) {
                notifSection("Push Notifications", icon: "bell.fill", binding: $pushEnabled)
                notifSection("Email Notifications", icon: "envelope.fill", binding: $emailEnabled)
                notifSection("Event Reminders", icon: "calendar.badge.clock", binding: $eventReminders)
                notifSection("Community Updates", icon: "person.2.fill", binding: $communityUpdates)
                notifSection("Ambassador Alerts", icon: "star.fill", binding: $ambassadorAlerts)
            }
            .padding(UNPSpacing.lg)
        }
        .background(UNPColor.background)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.copper)
                }
            }
        }
    }

    private func notifSection(_ label: String, icon: String, binding: Binding<Bool>) -> some View {
        HStack(spacing: UNPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(UNPColor.copper)
                .frame(width: 28)
            Text(label)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
            Spacer()
            Toggle("", isOn: binding)
                .tint(UNPColor.violet)
                .labelsHidden()
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}
