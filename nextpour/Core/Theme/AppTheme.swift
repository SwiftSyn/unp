import SwiftUI

enum ThemePreference: String {
    case system, day, night
}

@Observable
final class AppTheme {
    var preference: ThemePreference {
        didSet { UserDefaults.standard.set(preference.rawValue, forKey: "nextpour_theme") }
    }

    init() {
        let saved = UserDefaults.standard.string(forKey: "nextpour_theme") ?? ""
        preference = ThemePreference(rawValue: saved) ?? .system
    }

    var preferredColorScheme: ColorScheme? {
        switch preference {
        case .system: return nil
        case .day:    return .light
        case .night:  return .dark
        }
    }

    var toggleIcon: String {
        preference == .day ? "moon.fill" : "sun.max.fill"
    }

    var toggleColor: Color {
        preference == .day ? UNPColor.violet : UNPColor.gold
    }

    func toggle() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            preference = (preference == .day) ? .night : .day
        }
    }

    var background: Color    { UNPColor.background }
    var surface: Color       { UNPColor.surface }
    var text: Color          { UNPColor.textPrimary }
    var textSecondary: Color { UNPColor.textSecondary }
    var accent: Color        { UNPColor.copper }
}
