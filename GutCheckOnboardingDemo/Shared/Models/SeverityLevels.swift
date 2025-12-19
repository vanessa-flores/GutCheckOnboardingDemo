import Foundation

// MARK: - Severity

/// Severity levels for symptom tracking
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

/// Menstrual flow heaviness levels
enum FlowLevel: String, Codable, CaseIterable, Identifiable {
    case light = "Light"
    case medium = "Medium"
    case heavy = "Heavy"

    var id: String { rawValue }
    
    var numericValue: Int {
        switch self {
        case .light: return 1
        case .medium: return 2
        case .heavy: return 3
        }
    }
}
