import Foundation

// MARK: - Daily Log

/// Wrapper for all tracking data on a given day.
/// Provides a single access point for a user's complete daily health record.
struct DailyLog: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let date: Date
    
    // Mental health specific tracking
    var mood: Mood?

    // Period-specific daily data
    var flowLevel: FlowLevel?
    var hadSpotting: Bool

    // General symptom tracking
    var symptomLogs: [SymptomLog]
    var reflectionNotes: String?
    var completedAt: Date?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        date: Date,
        flowLevel: FlowLevel? = nil,
        hadSpotting: Bool = false,
        symptomLogs: [SymptomLog] = [],
        reflectionNotes: String? = nil,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.date = date.startOfDay
        self.flowLevel = flowLevel
        self.hadSpotting = hadSpotting
        self.symptomLogs = symptomLogs
        self.reflectionNotes = reflectionNotes
        self.completedAt = completedAt
    }
}

// MARK: - DailyLog Computed Properties

extension DailyLog {
    var isCompleted: Bool {
        completedAt != nil
    }

    var hasData: Bool {
        !symptomLogs.isEmpty || flowLevel != nil || hadSpotting || reflectionNotes != nil
    }

    var symptomCount: Int {
        symptomLogs.count
    }

    var hasPeriodLogged: Bool {
        flowLevel != nil
    }
}

// MARK: - DailyLog Mutations

extension DailyLog {
    func addingSymptomLog(_ log: SymptomLog) -> DailyLog {
        var copy = self
        copy.symptomLogs.append(log)
        return copy
    }

    func removingSymptomLog(withId id: UUID) -> DailyLog {
        var copy = self
        copy.symptomLogs.removeAll { $0.id == id }
        return copy
    }

    func withReflectionNotes(_ notes: String?) -> DailyLog {
        var copy = self
        copy.reflectionNotes = notes
        return copy
    }

    func markCompleted() -> DailyLog {
        var copy = self
        copy.completedAt = Date()
        return copy
    }

    func markIncomplete() -> DailyLog {
        var copy = self
        copy.completedAt = nil
        return copy
    }
}

// MARK: - DailyLog Factory

extension DailyLog {
    static func today(for userId: UUID) -> DailyLog {
        DailyLog(userId: userId, date: Date())
    }

    static func forDate(_ date: Date, userId: UUID) -> DailyLog {
        DailyLog(userId: userId, date: date)
    }
}
