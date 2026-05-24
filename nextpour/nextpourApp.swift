import SwiftUI
import CoreData

@main
struct nextpourApp: App {
    let persistenceController = PersistenceController.shared
    @State private var theme = AppTheme()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(theme)
                .preferredColorScheme(theme.preferredColorScheme)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
