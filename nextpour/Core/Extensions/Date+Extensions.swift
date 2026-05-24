import Foundation

extension Date {
    func formatted(as style: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style
        return formatter.string(from: self)
    }

    var relativeDescription: String {
        let seconds = Int(-timeIntervalSinceNow)
        switch seconds {
        case 0..<60: return "just now"
        case 60..<3600: return "\(seconds / 60)m ago"
        case 3600..<86400: return "\(seconds / 3600)h ago"
        case 86400..<604800: return "\(seconds / 86400)d ago"
        default: return formatted(as: "MMM d")
        }
    }

    var timeString: String { formatted(as: "h:mm a") }
    var shortDate: String { formatted(as: "MMM d, yyyy") }
    var dayAndMonth: String { formatted(as: "MMM d") }
}
