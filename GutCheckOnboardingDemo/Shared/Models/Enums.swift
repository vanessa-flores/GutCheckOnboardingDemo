import Foundation

// MARK: - Symptom Category

/// Categories for organizing symptoms in the UI.
/// Ordered for display purposes.
enum SymptomCategory: String, Codable, CaseIterable, Identifiable {
    case digestive = "Digestive & Gut Health"
    case cycle = "Cycle & Hormonal"
    case energy = "Energy, Mood & Mental Clarity"
    case sleep = "Sleep & Temperature"
    case physical = "Physical & Pain"
    case other = "Other Symptoms"

    var id: String { rawValue }

    /// Display order for UI sorting
    var displayOrder: Int {
        switch self {
        case .digestive: return 0
        case .cycle: return 1
        case .energy: return 2
        case .sleep: return 3
        case .physical: return 4
        case .other: return 5
        }
    }
}

// MARK: - Severity

/// Severity levels for symptom tracking
enum Severity: String, Codable, CaseIterable, Identifiable {
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"

    var id: String { rawValue }

    /// Numeric value for aggregation/analysis
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
}

// MARK: - Future Implementation

/// Categories for habit tracking
/// - Note: UI implementation planned for future release
enum HabitCategory: String, Codable, CaseIterable, Identifiable {
    case supplement = "Supplements"
    case food = "Food & Nutrition"
    case exercise = "Exercise & Movement"
    case sleep = "Sleep & Rest"
    case stress = "Stress Management"

    var id: String { rawValue }
}
