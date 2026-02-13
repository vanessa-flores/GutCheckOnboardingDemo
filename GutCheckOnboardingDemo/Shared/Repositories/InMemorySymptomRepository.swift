import Foundation

// MARK: - In-Memory Symptom Repository

/// In-memory implementation of symptom repository protocols.
/// Intended for development, testing, and demo purposes.
/// Replace with a backend-connected implementation when ready.
final class InMemorySymptomRepository: DailyLogRepositoryProtocol {

    // MARK: - Singleton

    static let shared = InMemorySymptomRepository()

    // MARK: - Storage

    private var symptoms: [Symptom] = []
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

