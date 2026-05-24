import SwiftUI

struct WelcomeView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @State private var nameInput = ""
    @State private var showEditProfile = false
    @State private var showOnboarding = false
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        ZStack {
            Image("LoginSplash")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [.clear, UNPColor.midnight.opacity(0.5), UNPColor.midnight],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: UNPSpacing.xs) {
                    Image("UNPLoginMark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 52)
                    Text("Until your next pour")
                        .font(UNPFontStyle.body(14))
                        .foregroundStyle(UNPColor.textSecondary)
                        .italic()
                }

                Spacer()

                VStack(spacing: UNPSpacing.md) {
                    VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                        Text("What's your name?")
                            .font(UNPFontStyle.caption())
                            .foregroundStyle(UNPColor.textSecondary)
                            .padding(.horizontal, 4)

                        HStack(spacing: UNPSpacing.sm) {
                            TextField("", text: $nameInput)
                                .font(UNPFontStyle.body())
                                .foregroundStyle(UNPColor.textPrimary)
                                .focused($nameFieldFocused)
                                .submitLabel(.done)
                                .onSubmit {
                                    if !nameInput.trimmingCharacters(in: .whitespaces).isEmpty {
                                        showEditProfile = true
                                    }
                                }
                                .padding(.vertical, 13)
                                .padding(.horizontal, UNPSpacing.md)
                                .background(UNPColor.surface)
                                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                                .overlay(
                                    RoundedRectangle(cornerRadius: UNPRadius.medium)
                                        .stroke(UNPColor.ember.opacity(0.3), lineWidth: 1)
                                )

                            Button {
                                nameFieldFocused = false
                                if !nameInput.trimmingCharacters(in: .whitespaces).isEmpty {
                                    showEditProfile = true
                                }
                            } label: {
                                Text("Continue")
                                    .font(UNPFontStyle.caption())
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, UNPSpacing.md)
                                    .padding(.vertical, 13)
                                    .background(UNPColor.emberGradient)
                                    .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                            }
                        }
                    }

                    Button {
                        nameFieldFocused = false
                        showOnboarding = true
                    } label: {
                        Text("Take a Quick Tour")
                            .font(UNPFontStyle.heading(16))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                            .overlay(
                                RoundedRectangle(cornerRadius: UNPRadius.medium)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    }

                    Button {
                        nameFieldFocused = false
                        Task { await viewModel.signInWithApple() }
                    } label: {
                        HStack(spacing: UNPSpacing.sm) {
                            if viewModel.isLoading {
                                LoadingSpinner(color: .white, size: 18)
                            } else {
                                Image(systemName: "apple.logo")
                            }
                            Text("Sign in with Apple")
                                .font(UNPFontStyle.heading(16))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal, UNPSpacing.lg)
                .padding(.bottom, UNPSpacing.xxl)
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(prefillName: nameInput, onComplete: {
                showEditProfile = false
            })
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(onComplete: {
                viewModel.continueAsGuest()
            })
        }
    }
}
