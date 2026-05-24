import SwiftUI

struct RootView: View {
    @State private var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isAuthenticated {
            AppTabView()
        } else {
            WelcomeView()
                .environment(authViewModel)
        }
    }
}
