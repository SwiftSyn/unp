import SwiftUI

enum UNPColor {
    static let background      = Color("np_background")
    static let surface         = Color("np_surface")
    static let surfaceElevated = Color("np_surfaceElevated")
    static let surfaceHigh     = Color("np_surfaceHigh")
    static let textPrimary     = Color("np_textPrimary")
    static let textSecondary   = Color("np_textSecondary")
    static let textMuted       = Color("np_textMuted")

    static let ember       = Color(hex: "#F59E0B")
    static let emberLight  = Color(hex: "#FCD34D")
    static let emberDeep   = Color(hex: "#D97706")
    static let neon        = Color(hex: "#8B5CF6")
    static let neonLight   = Color(hex: "#A78BFA")
    static let neonDeep    = Color(hex: "#6D28D9")
    static let azure       = Color(hex: "#06B6D4")
    static let azureLight  = Color(hex: "#67E8F9")
    static let midnight    = Color(hex: "#0A0A0F")
    static let midnightRich = Color(hex: "#1A1A2E")

    static let copper      = Color(hex: "#F59E0B")
    static let copperLight = Color(hex: "#FCD34D")
    static let violet      = Color(hex: "#8B5CF6")
    static let violetLight = Color(hex: "#A78BFA")
    static let success     = Color(hex: "#06B6D4")
    static let warning     = Color(hex: "#F59E0B")
    static let error       = Color(hex: "#EF4444")
    static let bronze      = Color(hex: "#D97706")
    static let silver      = Color(hex: "#94A3B8")
    static let gold        = Color(hex: "#FCD34D")
    static let cream       = Color(hex: "#FEF3C7")

    static func gradient(_ color: Color, opacity: Double = 0.8) -> LinearGradient {
        LinearGradient(colors: [color.opacity(opacity), color.opacity(0)], startPoint: .bottom, endPoint: .top)
    }

    static let emberGradient = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let neonGradient = LinearGradient(
        colors: [Color(hex: "#A78BFA"), Color(hex: "#6D28D9")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let nightGradient = LinearGradient(
        colors: [Color(hex: "#0A0A0F"), Color(hex: "#1A1A2E")],
        startPoint: .top, endPoint: .bottom
    )
    static let heroGradient = LinearGradient(
        colors: [Color(hex: "#1A1A2E"), Color(hex: "#0A0A0F")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let glowGradient = LinearGradient(
        colors: [Color(hex: "#8B5CF6").opacity(0.3), Color(hex: "#F59E0B").opacity(0.15), Color(hex: "#0A0A0F").opacity(0)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let copperGradient = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let violetGradient = LinearGradient(
        colors: [Color(hex: "#A78BFA"), Color(hex: "#6D28D9")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

#if canImport(UIKit)
import UIKit

extension UIColor {
    static let unpBackground = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#0A0A0F") : UIColor(hex: "#F8F6FF")
    }
    static let unpSurface = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#16162A") : UIColor(hex: "#FFFFFF")
    }
    static let unpSurfaceElevated = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#1E1E38") : UIColor(hex: "#EDE9FF")
    }
    static let unpSurfaceHigh = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#26264A") : UIColor(hex: "#E4DEFF")
    }
    static let unpTextPrimary = UIColor { t in
        t.userInterfaceStyle == .dark ? .white : UIColor(hex: "#0A0A0F")
    }
    static let unpTextSecondary = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#A0A0C0") : UIColor(hex: "#4A4A6A")
    }
    static let unpTextMuted = UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor(hex: "#606080") : UIColor(hex: "#8888AA")
    }

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
}
#elseif canImport(AppKit)
import AppKit

extension NSColor {
    static let unpBackground = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#0A0A0F") : NSColor(hex: "#F8F6FF")
    }
    static let unpSurface = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#16162A") : NSColor(hex: "#FFFFFF")
    }
    static let unpSurfaceElevated = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#1E1E38") : NSColor(hex: "#EDE9FF")
    }
    static let unpSurfaceHigh = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#26264A") : NSColor(hex: "#E4DEFF")
    }
    static let unpTextPrimary = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? .white : NSColor(hex: "#0A0A0F")
    }
    static let unpTextSecondary = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#A0A0C0") : NSColor(hex: "#4A4A6A")
    }
    static let unpTextMuted = NSColor { a in
        a.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(hex: "#606080") : NSColor(hex: "#8888AA")
    }

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
}
#endif


enum UNPRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
    static let pill: CGFloat = 50
}

enum UNPSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

enum UNPFontStyle {
    static func display(_ size: CGFloat = 28) -> Font { .system(size: size, weight: .bold, design: .rounded) }
    static func heading(_ size: CGFloat = 20) -> Font { .system(size: size, weight: .semibold) }
    static func body(_ size: CGFloat = 16) -> Font    { .system(size: size, weight: .regular) }
    static func caption(_ size: CGFloat = 13) -> Font { .system(size: size, weight: .medium) }
    static func label(_ size: CGFloat = 11) -> Font   { .system(size: size, weight: .semibold) }
}

enum UNPShadow {
    static let card = Shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    static let soft = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    static let glow: (Color) -> Shadow = { color in Shadow(color: color.opacity(0.5), radius: 20, x: 0, y: 0) }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func unpShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
