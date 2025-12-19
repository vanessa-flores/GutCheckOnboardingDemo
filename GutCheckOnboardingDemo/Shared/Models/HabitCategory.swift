import Foundation

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

