import Foundation

@Observable
final class AuthViewModel {
    private(set) var isAuthenticated: Bool
    private(set) var isLoading = false

    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "nextpour_onboarding_complete")
    }

    func signInWithApple() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        UserDefaults.standard.set(true, forKey: "nextpour_onboarding_complete")
        isAuthenticated = true
        isLoading = false
    }

    func continueAsGuest() {
        UserDefaults.standard.set(true, forKey: "nextpour_onboarding_complete")
        isAuthenticated = true
    }

    func signOut() {
        UserDefaults.standard.set(false, forKey: "nextpour_onboarding_complete")
        isAuthenticated = false
    }
}
