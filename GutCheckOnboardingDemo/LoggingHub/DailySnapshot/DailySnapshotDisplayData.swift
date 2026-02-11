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

    var symptomPreviewMain: String? {
        guard !symptomNames.isEmpty else { return nil }

        if symptomNames.count <= 2 {
            return symptomNames.joined(separator: ", ")
        } else {
            return symptomNames.prefix(2).joined(separator: ", ")
        }
    }

    var symptomOverflowCount: Int? {
        guard symptomNames.count > 2 else { return nil }
        return symptomNames.count - 2
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
