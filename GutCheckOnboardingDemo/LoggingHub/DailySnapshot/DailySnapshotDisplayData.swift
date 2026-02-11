import Foundation

// MARK: - DailySnapshotDisplayData

/// Display data for the read-only Daily Snapshot card shown on the Logging Hub.
/// Pre-formatted, ready-to-render data with no business logic.
struct DailySnapshotDisplayData: Equatable {
    let moodEmoji: String?
    let moodLabel: String?
    let symptomNames: [String]
    let flowLabel: String?

    var hasAnyData: Bool {
        moodEmoji != nil || !symptomNames.isEmpty || flowLabel != nil
    }

    var symptomsList: String? {
        guard !symptomNames.isEmpty else { return nil }
        return symptomNames.joined(separator: ", ")
    }

    static let empty = DailySnapshotDisplayData(
        moodEmoji: nil,
        moodLabel: nil,
        symptomNames: [],
        flowLabel: nil
    )
}
