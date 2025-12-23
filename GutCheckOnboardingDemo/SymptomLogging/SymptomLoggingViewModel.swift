import SwiftUI
import Observation

@Observable
class SymptomLoggingViewModel {

    // MARK: - State

    var trackedSymptoms: [Symptom] = []
    var todaysLogs: [SymptomLog] = []
    var expandedSymptomId: UUID? = nil
    var isLoading: Bool = false

    // MARK: - Private Properties

    private let repository: InMemorySymptomRepository
    private let userId: UUID

    // MARK: - Computed Properties

    /// Number of symptoms logged today
    var loggedCount: Int {
        todaysLogs.count
    }

    /// Most recent log timestamp
    var lastUpdated: Date? {
        todaysLogs.map(\.timestamp).max()
    }

    /// Whether user has any tracked symptoms
    var hasTrackedSymptoms: Bool {
        !trackedSymptoms.isEmpty
    }

    /// Formatted date string for header
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "Today \u{2022} \(formatter.string(from: Date()))"
    }

    /// Summary text for footer
    var summaryText: String {
        switch loggedCount {
        case 0:
            return "No symptoms logged today"
        case 1:
            return "1 symptom logged today"
        default:
            return "\(loggedCount) symptoms logged today"
        }
    }

    /// Last updated text for footer
    var lastUpdatedText: String? {
        guard let lastUpdated else { return nil }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Last updated: \(formatter.localizedString(for: lastUpdated, relativeTo: Date()))"
    }

    // MARK: - Initialization

    init(
        repository: InMemorySymptomRepository = .shared,
        userId: UUID
    ) {
        self.repository = repository
        self.userId = userId
    }

    // MARK: - Data Loading

    /// Loads tracked symptoms and today's logs from repository
    func loadData() {
        isLoading = true

        // Fetch user's tracked symptoms
        trackedSymptoms = repository.trackedSymptoms(for: userId)

        // Fetch today's symptom logs
        todaysLogs = repository.logs(for: userId, on: Date())

        isLoading = false
    }
    
    func getUserSymptomPreferences() -> [UserSymptomPreference] {
        repository.preferences(for: userId)
    }

    // MARK: - Symptom Logging

    /// Logs a symptom for today (creates new log entry)
    /// - Parameters:
    ///   - symptom: The symptom to log
    ///   - severity: Optional severity level (can be set later)
    func logSymptom(_ symptom: Symptom, severity: Severity? = nil) {
        // Check if already logged today
        guard getLog(for: symptom) == nil else {
            // Already logged, just expand it
            expandedSymptomId = symptom.id
            return
        }

        // Create new log (severity is nil by default, user can optionally set it)
        let log = SymptomLog(
            userId: userId,
            symptomId: symptom.id,
            date: Date(),
            timestamp: Date(),
            severity: severity
        )

        // Save to repository
        repository.save(log: log)

        // Update local state
        todaysLogs.append(log)

        // Expand to show severity picker
        expandedSymptomId = symptom.id
    }

    /// Updates the severity for an existing symptom log
    /// - Parameters:
    ///   - symptom: The symptom to update
    ///   - severity: The new severity level
    func updateSeverity(_ symptom: Symptom, severity: Severity) {
        guard let existingLog = getLog(for: symptom) else { return }

        // Create updated log with new severity and timestamp
        let updatedLog = existingLog
            .withSeverity(severity)

        // Update in repository
        repository.update(log: updatedLog)

        // Update local state
        if let index = todaysLogs.firstIndex(where: { $0.id == existingLog.id }) {
            todaysLogs[index] = updatedLog
        }

        // Collapse after brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.expandedSymptomId = nil
        }
    }

    /// Removes a symptom log for today
    /// - Parameter symptom: The symptom whose log should be removed
    func removeLog(_ symptom: Symptom) {
        guard let existingLog = getLog(for: symptom) else { return }

        // Remove from repository
        repository.remove(logId: existingLog.id)

        // Update local state
        todaysLogs.removeAll { $0.id == existingLog.id }

        // Collapse
        expandedSymptomId = nil
    }

    // MARK: - Expansion State

    /// Toggles the expanded state for a symptom
    /// - Parameter symptomId: The symptom ID to toggle
    func toggleExpanded(_ symptomId: UUID) {
        if expandedSymptomId == symptomId {
            // Collapse if already expanded
            expandedSymptomId = nil
        } else {
            // Expand (will automatically collapse other)
            expandedSymptomId = symptomId
        }
    }

    // MARK: - Helpers

    /// Returns the log for a specific symptom if it exists for today
    /// - Parameter symptom: The symptom to look up
    /// - Returns: The symptom log if found, nil otherwise
    func getLog(for symptom: Symptom) -> SymptomLog? {
        todaysLogs.first { $0.symptomId == symptom.id }
    }

    /// Whether a symptom is currently logged today
    func isLogged(_ symptom: Symptom) -> Bool {
        getLog(for: symptom) != nil
    }

    /// Whether a symptom's row is currently expanded
    func isExpanded(_ symptom: Symptom) -> Bool {
        expandedSymptomId == symptom.id
    }
}
