import Foundation

// MARK: - Daily Log

/// Wrapper for all tracking data on a given day.
/// Provides a single access point for a user's complete daily health record.
/// Designed for easy backend integration - swap repository implementation when ready.
struct DailyLog: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let date: Date                    // Normalized to start of day
    var symptomLogs: [SymptomLog]
    var cycleLog: CycleLog?           // If period tracked that day
    var reflectionNotes: String?      // End-of-day reflection
    var completedAt: Date?            // When user marked day as "complete"

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        date: Date,
        symptomLogs: [SymptomLog] = [],
        cycleLog: CycleLog? = nil,
        reflectionNotes: String? = nil,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.date = date.startOfDay
        self.symptomLogs = symptomLogs
        self.cycleLog = cycleLog
        self.reflectionNotes = reflectionNotes
        self.completedAt = completedAt
    }
}

// MARK: - DailyLog Computed Properties

extension DailyLog {
    /// Whether the user has completed logging for this day
    var isCompleted: Bool {
        completedAt != nil
    }

    /// Whether this log has any data (symptoms, cycle, or notes)
    var hasData: Bool {
        !symptomLogs.isEmpty || cycleLog != nil || reflectionNotes != nil
    }

    /// Total number of symptoms logged today
    var symptomCount: Int {
        symptomLogs.count
    }

    /// Whether the user logged their period this day
    var hasPeriodLogged: Bool {
        cycleLog != nil
    }
}

// MARK: - DailyLog Mutations

extension DailyLog {
    /// Returns a copy with added symptom log
    func addingSymptomLog(_ log: SymptomLog) -> DailyLog {
        var copy = self
        copy.symptomLogs.append(log)
        return copy
    }

    /// Returns a copy with removed symptom log
    func removingSymptomLog(withId id: UUID) -> DailyLog {
        var copy = self
        copy.symptomLogs.removeAll { $0.id == id }
        return copy
    }

    /// Returns a copy with updated cycle log
    func withCycleLog(_ cycleLog: CycleLog?) -> DailyLog {
        var copy = self
        copy.cycleLog = cycleLog
        return copy
    }

    /// Returns a copy with updated reflection notes
    func withReflectionNotes(_ notes: String?) -> DailyLog {
        var copy = self
        copy.reflectionNotes = notes
        return copy
    }

    /// Returns a copy marked as completed
    func markCompleted() -> DailyLog {
        var copy = self
        copy.completedAt = Date()
        return copy
    }

    /// Returns a copy marked as incomplete
    func markIncomplete() -> DailyLog {
        var copy = self
        copy.completedAt = nil
        return copy
    }
}

// MARK: - DailyLog Factory

extension DailyLog {
    /// Creates an empty daily log for today
    static func today(for userId: UUID) -> DailyLog {
        DailyLog(userId: userId, date: Date())
    }

    /// Creates an empty daily log for a specific date
    static func forDate(_ date: Date, userId: UUID) -> DailyLog {
        DailyLog(userId: userId, date: date)
    }
}
