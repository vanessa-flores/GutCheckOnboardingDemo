import Foundation

// MARK: - Symptom Catalog Protocol

protocol SymptomCatalogProtocol {
    var allSymptoms: [Symptom] { get }
    func symptom(withId id: UUID) -> Symptom?
    func symptomsGroupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])]
}

// MARK: - Symptom Preference Protocol

protocol SymptomPreferenceProtocol {
    func preferences(for userId: UUID) -> [UserSymptomPreference]
    func activePreferences(for userId: UUID) -> [UserSymptomPreference]
    func save(preference: UserSymptomPreference)
}

// MARK: - Daily Log Repository Protocol

protocol DailyLogRepositoryProtocol: SymptomCatalogProtocol {
    func dailyLogs(for userId: UUID) -> [DailyLog]
    func dailyLog(for userId: UUID, on date: Date) -> DailyLog?
    func save(dailyLog: DailyLog)
}
