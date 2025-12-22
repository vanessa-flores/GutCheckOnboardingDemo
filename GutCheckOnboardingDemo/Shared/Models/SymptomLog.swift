import Foundation

// MARK: - Symptom Log

/// Records a user's symptom entry for a specific day.
/// Each log captures a single symptom occurrence with severity and optional notes.
/// Designed for easy backend integration - swap repository implementation when ready.
struct SymptomLog: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let symptomId: UUID
    let date: Date         // Day of logging, normalized to start of day
    let timestamp: Date    // Exact time logged (for quick-capture ordering)
    var severity: Severity
    var notes: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        symptomId: UUID,
        date: Date,
        timestamp: Date = Date(),
        severity: Severity,
        notes: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.symptomId = symptomId
        self.date = date.startOfDay
        self.timestamp = timestamp
        self.severity = severity
        self.notes = notes
    }
}

// MARK: - SymptomLog Extensions

extension SymptomLog {
    /// Creates a quick-capture log with current timestamp
    static func quickCapture(
        userId: UUID,
        symptomId: UUID,
        severity: Severity = .moderate
    ) -> SymptomLog {
        let now = Date()
        return SymptomLog(
            userId: userId,
            symptomId: symptomId,
            date: now,
            timestamp: now,
            severity: severity
        )
    }

    /// Returns a copy with updated severity
    func withSeverity(_ severity: Severity) -> SymptomLog {
        var copy = self
        copy.severity = severity
        return copy
    }

    /// Returns a copy with updated notes
    func withNotes(_ notes: String?) -> SymptomLog {
        var copy = self
        copy.notes = notes
        return copy
    }
}

// MARK: - SymptomLog Array Extensions

extension Array where Element == SymptomLog {
    /// Returns logs sorted by timestamp (most recent first)
    func sortedByTimestamp(ascending: Bool = false) -> [SymptomLog] {
        sorted { ascending ? $0.timestamp < $1.timestamp : $0.timestamp > $1.timestamp }
    }

    /// Returns logs filtered to a specific date
    func forDate(_ date: Date) -> [SymptomLog] {
        let targetDay = date.startOfDay
        return filter { $0.date == targetDay }
    }

    /// Returns logs filtered to a date range (inclusive)
    func inDateRange(from startDate: Date, to endDate: Date) -> [SymptomLog] {
        let start = startDate.startOfDay
        let end = endDate.startOfDay
        return filter { $0.date >= start && $0.date <= end }
    }
}
