import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    @State private var viewModel = OnboardingViewModel()

    private let steps = [
        OnboardingStep(icon: "wineglass.fill", title: "Your Next Pour", body: "Discover craft cocktails, find your favourite bartenders, and explore the best venues in your city."),
        OnboardingStep(icon: "person.3.fill", title: "Join Pour Circles", body: "Connect with like-minded pour enthusiasts, share discoveries, and plan nights out together."),
        OnboardingStep(icon: "star.fill", title: "Earn Rewards", body: "Every pour, share, and event earns you points. Unlock Bronze, Silver, and Gold tier benefits.")
    ]

    var body: some View {
        ZStack {
            UNPColor.background.ignoresSafeArea()

            VStack(spacing: UNPSpacing.xxl) {
                HStack {
                    Spacer()
                    Button("Skip") { viewModel.skip() }
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textSecondary)
                        .padding()
                }

                Spacer()

                let step = steps[viewModel.currentStep]
                VStack(spacing: UNPSpacing.lg) {
                    Image(systemName: step.icon)
                        .font(.system(size: 64))
                        .foregroundStyle(UNPColor.copper)
                    Text(step.title)
                        .font(UNPFontStyle.display(28))
                        .foregroundStyle(UNPColor.textPrimary)
                        .multilineTextAlignment(.center)
                    Text(step.body)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, UNPSpacing.lg)
                }

                if viewModel.currentStep == 0 {
                    TextField("Your name", text: $viewModel.name)
                        .foregroundStyle(UNPColor.textPrimary)
                        .padding()
                        .background(UNPColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
                        .padding(.horizontal, UNPSpacing.lg)
                }

                Spacer()

                HStack(spacing: UNPSpacing.sm) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Capsule()
                            .fill(i == viewModel.currentStep ? UNPColor.copper : UNPColor.surface)
                            .frame(width: i == viewModel.currentStep ? 24 : 8, height: 8)
                            .animation(.spring, value: viewModel.currentStep)
                    }
                }

                PrimaryButton(
                    title: viewModel.currentStep == steps.count - 1 ? "Get Started" : "Next",
                    action: { viewModel.nextStep() }
                )
                .disabled(!viewModel.canProceed)
                .opacity(viewModel.canProceed ? 1 : 0.5)
                .padding(.horizontal, UNPSpacing.lg)
                .padding(.bottom, UNPSpacing.xxl)
            }
        }
        .onChange(of: viewModel.isComplete) { _, complete in
            if complete { onComplete() }
        }
    }
}

private struct OnboardingStep {
    let icon: String
    let title: String
    let body: String
}
