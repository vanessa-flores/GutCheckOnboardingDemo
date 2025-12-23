import SwiftUI
import Observation

@Observable
class QuickLogViewModel {

    // MARK: - State

    let eventSymptoms: [SymptomCategory: [Symptom]]

    // MARK: - Private Properties

    private let repository: InMemorySymptomRepository
    private let userId: UUID

    // MARK: - Computed Properties

    /// Categories in display order for Quick Log screen
    var orderedCategories: [SymptomCategory] {
        [
            .sleepTemperature,
            .physicalPain,
            .energyMoodMental,
            .digestiveGutHealth
        ].filter { eventSymptoms[$0]?.isEmpty == false }
    }

    // MARK: - Initialization

    init(
        repository: InMemorySymptomRepository = .shared,
        userId: UUID
    ) {
        self.repository = repository
        self.userId = userId
        self.eventSymptoms = Self.loadEventSymptoms(from: repository)
    }

    // MARK: - Symptom Loading

    /// Loads event-based symptoms from repository and groups by category
    private static func loadEventSymptoms(from repository: InMemorySymptomRepository) -> [SymptomCategory: [Symptom]] {
        let allSymptoms = repository.allSymptoms

        // Filter to only event-based symptoms using the isEventBased property
        let eventSymptoms = allSymptoms.filter { $0.isEventBased }

        // Group by category
        return Dictionary(grouping: eventSymptoms, by: \.category)
    }

    // MARK: - Symptom Logging

    /// Logs an event symptom with current timestamp (no severity)
    /// - Parameter symptom: The symptom to log
    func logSymptom(_ symptom: Symptom) {
        let now = Date()

        let log = SymptomLog(
            userId: userId,
            symptomId: symptom.id,
            date: now,
            timestamp: now,
            severity: nil
        )

        repository.save(log: log)
    }

    // MARK: - Navigation

    /// Navigates to the Dashboard tab
    func navigateToDashboard() {
        // Will be implemented when wiring up navigation
    }
}
