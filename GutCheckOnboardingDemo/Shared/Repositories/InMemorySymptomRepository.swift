import Foundation

// MARK: - In-Memory Symptom Repository

/// In-memory implementation of symptom repository protocols.
/// Perfect for development, testing, and demo purposes.
/// Replace with a backend-connected implementation when ready.
final class InMemorySymptomRepository: SymptomRepositoryProtocol, DailyLogRepositoryProtocol {

    // MARK: - Singleton

    static let shared = InMemorySymptomRepository()

    // MARK: - Storage

    private var symptoms: [Symptom] = []
    private var preferences: [UUID: [UserSymptomPreference]] = [:]  // userId -> preferences
    private var symptomLogs: [UUID: [SymptomLog]] = [:]             // userId -> logs
    private var dailyLogs: [UUID: [Date: DailyLog]] = [:]            // userId -> date -> dailyLog

    // MARK: - Initialization

    private init() {
        // Load symptoms from static data
        self.symptoms = SymptomData.allSymptoms
    }

    // MARK: - SymptomRepositoryProtocol - Catalog

    var allSymptoms: [Symptom] {
        symptoms.sortedForDisplay()
    }

    func symptoms(for category: SymptomCategory) -> [Symptom] {
        symptoms
            .filter { $0.category == category }
            .sorted { $0.displayOrder < $1.displayOrder }
    }

    func symptom(withId id: UUID) -> Symptom? {
        symptoms.first { $0.id == id }
    }

    func symptomsGroupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])] {
        symptoms.groupedByCategory()
    }

    // MARK: - SymptomRepositoryProtocol - Preferences

    func preferences(for userId: UUID) -> [UserSymptomPreference] {
        preferences[userId] ?? []
    }

    func activePreferences(for userId: UUID) -> [UserSymptomPreference] {
        preferences(for: userId).activelyTracked
    }

    func save(preference: UserSymptomPreference) {
        var userPrefs = preferences[preference.userId] ?? []

        // Update existing or add new
        if let index = userPrefs.firstIndex(where: { $0.symptomId == preference.symptomId }) {
            userPrefs[index] = preference
        } else {
            userPrefs.append(preference)
        }

        preferences[preference.userId] = userPrefs
    }

    func remove(preferenceId: UUID) {
        for (userId, userPrefs) in preferences {
            preferences[userId] = userPrefs.filter { $0.id != preferenceId }
        }
    }

    func toggleTracking(symptomId: UUID, for userId: UUID) {
        var userPrefs = preferences[userId] ?? []

        if let index = userPrefs.firstIndex(where: { $0.symptomId == symptomId }) {
            // Toggle existing preference
            userPrefs[index] = userPrefs[index].toggled()
        } else {
            // Create new preference
            let newPref = UserSymptomPreference.track(symptomId: symptomId, for: userId)
            userPrefs.append(newPref)
        }

        preferences[userId] = userPrefs
    }

    // MARK: - SymptomRepositoryProtocol - Logs

    func logs(for userId: UUID) -> [SymptomLog] {
        symptomLogs[userId] ?? []
    }

    func logs(for userId: UUID, on date: Date) -> [SymptomLog] {
        logs(for: userId).forDate(date)
    }

    func logs(for userId: UUID, from startDate: Date, to endDate: Date) -> [SymptomLog] {
        logs(for: userId).inDateRange(from: startDate, to: endDate)
    }

    func save(log: SymptomLog) {
        var userLogs = symptomLogs[log.userId] ?? []
        userLogs.append(log)
        symptomLogs[log.userId] = userLogs
    }

    func update(log: SymptomLog) {
        var userLogs = symptomLogs[log.userId] ?? []
        if let index = userLogs.firstIndex(where: { $0.id == log.id }) {
            userLogs[index] = log
            symptomLogs[log.userId] = userLogs
        }
    }

    func remove(logId: UUID) {
        for (userId, userLogs) in symptomLogs {
            symptomLogs[userId] = userLogs.filter { $0.id != logId }
        }
    }

    // MARK: - DailyLogRepositoryProtocol

    func dailyLogs(for userId: UUID) -> [DailyLog] {
        Array(dailyLogs[userId]?.values ?? [:].values)
    }

    func dailyLog(for userId: UUID, on date: Date) -> DailyLog? {
        dailyLogs[userId]?[date.startOfDay]
    }

    func dailyLogs(for userId: UUID, from startDate: Date, to endDate: Date) -> [DailyLog] {
        let start = startDate.startOfDay
        let end = endDate.startOfDay

        return dailyLogs(for: userId).filter { log in
            log.date >= start && log.date <= end
        }
    }

    func getOrCreateTodaysLog(for userId: UUID) -> DailyLog {
        let today = Date().startOfDay

        if let existingLog = dailyLog(for: userId, on: today) {
            return existingLog
        }

        let newLog = DailyLog.today(for: userId)
        save(dailyLog: newLog)
        return newLog
    }

    func save(dailyLog: DailyLog) {
        var userLogs = dailyLogs[dailyLog.userId] ?? [:]
        userLogs[dailyLog.date] = dailyLog
        dailyLogs[dailyLog.userId] = userLogs
    }

    func update(dailyLog: DailyLog) {
        save(dailyLog: dailyLog)
    }
}

// MARK: - Convenience Extensions

extension InMemorySymptomRepository {
    /// Returns symptoms that a user is actively tracking
    func trackedSymptoms(for userId: UUID) -> [Symptom] {
        let trackedIds = activePreferences(for: userId).map { $0.symptomId }
        return trackedIds.compactMap { symptom(withId: $0) }
    }

    /// Returns whether a specific symptom is being tracked
    func isTracking(symptomId: UUID, for userId: UUID) -> Bool {
        preferences(for: userId).isTracking(symptomId: symptomId)
    }

    /// Bulk save preferences (used during onboarding)
    func savePreferences(_ newPreferences: [UserSymptomPreference], for userId: UUID) {
        for preference in newPreferences {
            save(preference: preference)
        }
    }

    /// Clear all preferences for a user (used during onboarding reset)
    func clearPreferences(for userId: UUID) {
        preferences[userId] = []
    }
}

// MARK: - CheckInRepository Extension

extension InMemorySymptomRepository: CheckInRepository {}
