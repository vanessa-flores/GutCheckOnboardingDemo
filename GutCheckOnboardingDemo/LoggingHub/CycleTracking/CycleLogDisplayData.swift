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

// MARK: - FlowTabDisplayData

/// Groups all display data for the Flow tab
struct FlowTabDisplayData {
    let flowPresenceOptions: [SelectableOption]
    let flowLevelOptions: [SelectableOption]
}
