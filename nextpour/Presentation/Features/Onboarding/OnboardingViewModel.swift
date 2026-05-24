import Foundation

@Observable
final class OnboardingViewModel {
    var name: String = ""
    var currentStep: Int = 0
    private(set) var isComplete = false

    let totalSteps = 3

    var canProceed: Bool {
        currentStep == 0 ? name.trimmingCharacters(in: .whitespaces).count >= 2 : true
    }

    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        } else {
            completeOnboarding()
        }
    }

    func skip() {
        completeOnboarding()
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "nextpour_onboarding_complete")
        UserDefaults.standard.set(name, forKey: "nextpour_user_name")
        isComplete = true
    }
}
