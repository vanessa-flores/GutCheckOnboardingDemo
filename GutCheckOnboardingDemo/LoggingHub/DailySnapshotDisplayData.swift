import Foundation

// MARK: - DailySnapshotDisplayData

/// Display data for the read-only Daily Snapshot card shown on the Logging Hub.
/// Pre-formatted, ready-to-render data with no business logic.
struct DailySnapshotDisplayData {
    let moodEmoji: String?
    let moodLabel: String?
    let symptomNames: [String]
    let flowLabel: String?

    var hasAnyData: Bool {
        moodEmoji != nil || !symptomNames.isEmpty || flowLabel != nil
    }

    var symptomPreview: String? {
        guard !symptomNames.isEmpty else { return nil }

        if symptomNames.count <= 2 {
            return symptomNames.joined(separator: ", ")
        } else {
            let preview = symptomNames.prefix(2).joined(separator: ", ")
            let remaining = symptomNames.count - 2
            return "\(preview) …+\(remaining)"
        }
    }

    var allSymptomsText: String? {
        guard !symptomNames.isEmpty else { return nil }
        return symptomNames.joined(separator: ", ")
    }

    var showOverflow: Bool {
        symptomNames.count > 2
    }

    static let empty = DailySnapshotDisplayData(
        moodEmoji: nil,
        moodLabel: nil,
        symptomNames: [],
        flowLabel: nil
    )
}
