import SwiftUI

struct AppTabView: View {
    @Environment(AppTheme.self) private var theme
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            PourCircleView()
                .tabItem {
                    Label("Pour Circle", systemImage: selectedTab == 1 ? "circle.hexagongrid.fill" : "circle.hexagongrid")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 2 ? "person.fill" : "person")
                }
                .tag(2)
        }
        .tint(UNPColor.ember)
        .onAppear {
            #if canImport(UIKit)
            configureTabBar()
            #endif
        }
    }

    #if canImport(UIKit)
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.086, green: 0.086, blue: 0.165, alpha: 1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    #endif
}
