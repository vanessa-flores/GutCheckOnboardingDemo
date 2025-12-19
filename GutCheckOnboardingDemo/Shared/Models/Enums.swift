import Foundation

// MARK: - Symptom Category

/// Categories for organizing symptoms in the UI.
/// Ordered for display purposes.
enum SymptomCategory: String, Codable, CaseIterable, Identifiable {
    case digestiveGutHealth = "Digestive & Gut Health"
    case cycleHormonal = "Cycle & Hormonal"
    case energyMoodMental = "Energy, Mood & Mental Clarity"
    case sleepTemperature = "Sleep & Temperature"
    case physicalPain = "Physical & Pain"
    case skinHairNails = "Skin, Hair & Nails"
    case sensory = "Sensory"
    case urogenital = "Urogenital"
    case otherPhysical = "Other Physical Symptoms"

    var id: String { rawValue }

    /// Display order for UI sorting
    var displayOrder: Int {
        switch self {
        case .digestiveGutHealth: return 0
        case .cycleHormonal: return 1
        case .energyMoodMental: return 2
        case .sleepTemperature: return 3
        case .physicalPain: return 4
        case .skinHairNails: return 5
        case .sensory: return 6
        case .urogenital: return 7
        case .otherPhysical: return 8
        }
    }
    
    var isFeatured: Bool {
        switch self {
        case .digestiveGutHealth, .cycleHormonal, .energyMoodMental, .sleepTemperature: return true
        default: return false
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
