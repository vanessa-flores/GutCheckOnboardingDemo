import Foundation

// MARK: - User Symptom Preference

/// Records a user's preference to track a specific symptom.
/// Each symptom the user selects during onboarding creates ONE UserSymptomPreference record.
/// Designed for easy backend integration - swap repository implementation when ready.
struct UserSymptomPreference: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let symptomId: UUID        // References a specific Symptom
    var isTracked: Bool        // Whether user is actively tracking this symptom
    let addedAt: Date          // When user first selected this symptom

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        symptomId: UUID,
        isTracked: Bool = true,
        addedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.symptomId = symptomId
        self.isTracked = isTracked
        self.addedAt = addedAt
    }
}

// MARK: - UserSymptomPreference Mutations

extension UserSymptomPreference {
    /// Returns a copy with tracking enabled
    func enabling() -> UserSymptomPreference {
        var copy = self
        copy.isTracked = true
        return copy
    }

    /// Returns a copy with tracking disabled
    func disabling() -> UserSymptomPreference {
        var copy = self
        copy.isTracked = false
        return copy
    }

    /// Returns a copy with toggled tracking status
    func toggled() -> UserSymptomPreference {
        var copy = self
        copy.isTracked.toggle()
        return copy
    }
}

// MARK: - UserSymptomPreference Factory

extension UserSymptomPreference {
    /// Creates a new preference for a symptom
    static func track(symptomId: UUID, for userId: UUID) -> UserSymptomPreference {
        UserSymptomPreference(userId: userId, symptomId: symptomId)
    }
}

// MARK: - UserSymptomPreference Array Extensions

extension Array where Element == UserSymptomPreference {
    /// Returns only actively tracked symptoms
    var activelyTracked: [UserSymptomPreference] {
        filter { $0.isTracked }
    }

    /// Returns symptom IDs that are actively tracked
    var trackedSymptomIds: Set<UUID> {
        Set(activelyTracked.map { $0.symptomId })
    }

    /// Returns preference for a specific symptom if it exists
    func preference(for symptomId: UUID) -> UserSymptomPreference? {
        first { $0.symptomId == symptomId }
    }

    /// Whether a specific symptom is being tracked
    func isTracking(symptomId: UUID) -> Bool {
        preference(for: symptomId)?.isTracked ?? false
    }
}
