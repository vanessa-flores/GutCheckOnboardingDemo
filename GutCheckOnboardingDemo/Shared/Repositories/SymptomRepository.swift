import Foundation

// MARK: - Symptom Repository Protocol

/// Protocol defining symptom data operations.
/// Allows swapping between in-memory and backend implementations.
protocol SymptomRepositoryProtocol {
    // MARK: - Symptom Catalog

    /// All available symptoms in the system
    var allSymptoms: [Symptom] { get }

    /// Returns symptoms filtered by category
    func symptoms(for category: SymptomCategory) -> [Symptom]

    /// Returns a specific symptom by ID
    func symptom(withId id: UUID) -> Symptom?

    /// Returns symptoms grouped by category for display
    func symptomsGroupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])]

    // MARK: - User Symptom Preferences

    /// Returns all symptom preferences for a user
    func preferences(for userId: UUID) -> [UserSymptomPreference]

    /// Returns actively tracked symptom preferences for a user
    func activePreferences(for userId: UUID) -> [UserSymptomPreference]

    /// Saves a symptom preference
    func save(preference: UserSymptomPreference)

    /// Removes a symptom preference
    func remove(preferenceId: UUID)

    /// Toggle tracking status for a symptom
    func toggleTracking(symptomId: UUID, for userId: UUID)

    // MARK: - Symptom Logs

    /// Returns all symptom logs for a user
    func logs(for userId: UUID) -> [SymptomLog]

    /// Returns symptom logs for a specific date
    func logs(for userId: UUID, on date: Date) -> [SymptomLog]

    /// Returns symptom logs within a date range
    func logs(for userId: UUID, from startDate: Date, to endDate: Date) -> [SymptomLog]

    /// Saves a symptom log
    func save(log: SymptomLog)

    /// Updates an existing symptom log
    func update(log: SymptomLog)

    /// Removes a symptom log
    func remove(logId: UUID)
}

// MARK: - Daily Log Repository Protocol

/// Protocol defining daily log operations.
protocol DailyLogRepositoryProtocol {
    /// Returns all daily logs for a user
    func dailyLogs(for userId: UUID) -> [DailyLog]

    /// Returns the daily log for a specific date
    func dailyLog(for userId: UUID, on date: Date) -> DailyLog?

    /// Returns daily logs within a date range
    func dailyLogs(for userId: UUID, from startDate: Date, to endDate: Date) -> [DailyLog]

    /// Creates or returns the daily log for today
    func getOrCreateTodaysLog(for userId: UUID) -> DailyLog

    /// Saves a daily log
    func save(dailyLog: DailyLog)

    /// Updates an existing daily log
    func update(dailyLog: DailyLog)
}
