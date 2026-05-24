import SwiftUI

enum UserAccountType: String, CaseIterable, Identifiable {
    case general = "General User"
    case ambassador = "Ambassador User"
    case ambassadorVenue = "Ambassador Venue User"
    var id: String { rawValue }
}

struct EditProfileView: View {
    let prefillName: String
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var email = ""
    @State private var location = ""
    @State private var accountType: UserAccountType = .general
    @State private var isSaving = false
    @State private var showSuccess = false

    init(prefillName: String, onComplete: @escaping () -> Void) {
        self.prefillName = prefillName
        self.onComplete = onComplete
        _name = State(initialValue: prefillName)
    }

    var body: some View {
        NavigationStack {
            if showSuccess {
                SuccessStateView(
                    title: "Profile Saved",
                    message: "Your profile has been updated.",
                    onDone: {
                        onComplete()
                        dismiss()
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(UNPColor.background)
            } else {
                formContent
            }
        }
    }

    private var formContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.xl) {
                photoSection
                accountTypeSection
                basicInfoSection
            }
            .padding(UNPSpacing.lg)
        }
        .background(UNPColor.background)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    onComplete()
                    dismiss()
                }
                .foregroundStyle(UNPColor.textSecondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSaving = true
                    Task {
                        try? await Task.sleep(for: .seconds(0.8))
                        isSaving = false
                        showSuccess = true
                    }
                } label: {
                    if isSaving {
                        LoadingSpinner(color: .black, size: 16)
                    } else {
                        Text("Save")
                            .font(UNPFontStyle.heading(15))
                            .foregroundStyle(.black)
                            .padding(.horizontal, UNPSpacing.md)
                            .padding(.vertical, 6)
                            .background(UNPColor.copper)
                            .clipShape(Capsule())
                    }
                }
                .disabled(isSaving)
            }
        }
    }

    private var photoSection: some View {
        VStack(spacing: UNPSpacing.sm) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(UNPColor.surface)
                    .frame(width: 88, height: 88)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(UNPColor.textMuted)
                    )
                Circle()
                    .fill(UNPColor.surfaceElevated)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(UNPColor.copper)
                    )
            }
            Text("Tap to change photo")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textMuted)
        }
    }

    private var accountTypeSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("Account Type")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)

            Menu {
                ForEach(UserAccountType.allCases) { type in
                    Button(type.rawValue) { accountType = type }
                }
            } label: {
                HStack {
                    Text(accountType.rawValue)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 13))
                        .foregroundStyle(UNPColor.textMuted)
                }
                .padding(UNPSpacing.md)
                .background(UNPColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
            }

            if accountType != .general {
                paidAmbassadorCard
            }
        }
    }

    private var paidAmbassadorCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text("Paid Ambassador")
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                TagBadge(text: accountType == .ambassadorVenue ? "Venue" : "User", color: UNPColor.copper)
            }
            Text("Select your paid tier and billing preference.")
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
            HStack(spacing: UNPSpacing.sm) {
                tierOption("Bronze", color: UNPColor.bronze)
                tierOption("Silver", color: UNPColor.silver)
                tierOption("Gold", color: UNPColor.gold)
            }
            HStack(spacing: UNPSpacing.sm) {
                billingOption("Monthly")
                billingOption("Annually")
            }
        }
        .padding(UNPSpacing.md)
        .background(UNPColor.neon.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: UNPRadius.large)
                .stroke(UNPColor.neon.opacity(0.3), lineWidth: 1)
        )
    }

    private func tierOption(_ label: String, color: Color) -> some View {
        Text(label)
            .font(UNPFontStyle.caption())
            .foregroundStyle(color)
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.xs)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    private func billingOption(_ label: String) -> some View {
        Text(label)
            .font(UNPFontStyle.caption())
            .foregroundStyle(UNPColor.textSecondary)
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.xs)
            .background(UNPColor.surface)
            .clipShape(Capsule())
    }

    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            Text("Basic Information")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)

            profileField(label: "Name", value: $name, placeholder: "Your full name")
            profileField(label: "Email", value: $email, placeholder: "your@email.com", keyboard: .emailAddress)
            profileField(label: "Location", value: $location, placeholder: "City, State")
        }
    }

    private func profileField(
        label: String,
        value: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.textSecondary)
            TextField(placeholder, text: value)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .padding(UNPSpacing.md)
                .background(UNPColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
        }
    }
}
