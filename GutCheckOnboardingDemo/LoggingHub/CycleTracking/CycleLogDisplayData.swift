import Foundation

// MARK: - Display Data Types for CycleLogModal

/// Display data types for "dumb" views in CycleLogModal.
/// These views receive pre-formatted data and report user actions via callbacks.
/// All business logic lives in CycleLogViewModel.

// MARK: - SelectableOption

/// Generic struct for simple selectable items (Yes/No, Light/Medium/Heavy)
struct SelectableOption: Identifiable {
    let id: String          // Unique identifier (e.g., "yes", "light")
    let title: String       // Display text
    let isSelected: Bool
}

// MARK: - SymptomDisplayData

/// Individual symptom item (needs UUID for toggle callback)
struct SymptomDisplayData: Identifiable {
    let id: UUID
    let name: String
    let isSelected: Bool
}

// MARK: - SymptomCategoryDisplayData

/// Grouped symptom category with symptoms
struct SymptomCategoryDisplayData: Identifiable {
    let id: String              // Category raw value
    let title: String           // Display title (e.g., "Digestive & Gut Health")
    let symptoms: [SymptomDisplayData]
}

// MARK: - FlowTabDisplayData

/// Groups all display data for the Flow tab
struct FlowTabDisplayData {
    let flowPresenceOptions: [SelectableOption]
    let flowLevelOptions: [SelectableOption]
}

// MARK: - SymptomsTabDisplayData

/// Groups all display data for the Symptoms tab
struct SymptomsTabDisplayData {
    let categories: [SymptomCategoryDisplayData]
    let selectionCountText: String    // "3 symptoms selected"
}
