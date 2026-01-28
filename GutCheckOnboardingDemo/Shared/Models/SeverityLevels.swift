import Foundation

// MARK: - Severity

enum Severity: String, Codable, CaseIterable, Identifiable {
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"

    var id: String { rawValue }

    var numericValue: Int {
        switch self {
        case .mild: return 1
        case .moderate: return 2
        case .severe: return 3
        }
    }
}

// MARK: - Flow Level

enum FlowLevel: String, Codable, CaseIterable, Identifiable {
    case unspecified
    case light
    case medium
    case heavy
    case none

    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .light: return "Light"
        case .medium: return "Medium"
        case .heavy: return "Heavy"
        case .none: return "No Flow" // User is tracking period but no bleeding this day
        case .unspecified: return "On Period"
        }
    }

    var numericValue: Int {
        switch self {
        case .light: return 1
        case .medium: return 2
        case .heavy: return 3
        case .none: return 0
        case .unspecified: return 0
        }
    }

    var isActualFlow: Bool {
        switch self {
        case .light, .medium, .heavy:
            return true
        case .unspecified, .none:
            return false
        }
    }
}
