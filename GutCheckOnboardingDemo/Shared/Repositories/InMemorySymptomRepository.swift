import Foundation

// MARK: - In-Memory Symptom Repository

/// In-memory implementation of symptom repository protocols.
/// Intended for development, testing, and demo purposes.
/// Replace with a backend-connected implementation when ready.
final class InMemorySymptomRepository: SymptomPreferenceProtocol, DailyLogRepositoryProtocol {

    // MARK: - Singleton

    static let shared = InMemorySymptomRepository()

    // MARK: - Storage

    private var symptoms: [Symptom] = []
    private var preferences: [UUID: [UserSymptomPreference]] = [:]  // userId -> preferences
    private var dailyLogs: [UUID: [Date: DailyLog]] = [:]            // userId -> date -> dailyLog

    // MARK: - Initialization

    private init() {
        // Load symptoms from static data
        self.symptoms = SymptomData.allSymptoms
    }

    // MARK: - SymptomCatalogProtocol

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

    // MARK: - SymptomPreferenceProtocol

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

    // MARK: - DailyLogRepositoryProtocol

    func dailyLogs(for userId: UUID) -> [DailyLog] {
        Array(dailyLogs[userId]?.values ?? [:].values)
    }

    func dailyLog(for userId: UUID, on date: Date) -> DailyLog? {
        dailyLogs[userId]?[date.startOfDay]
    }

    func save(dailyLog: DailyLog) {
        var userLogs = dailyLogs[dailyLog.userId] ?? [:]
        userLogs[dailyLog.date] = dailyLog
        dailyLogs[dailyLog.userId] = userLogs
    }
}

