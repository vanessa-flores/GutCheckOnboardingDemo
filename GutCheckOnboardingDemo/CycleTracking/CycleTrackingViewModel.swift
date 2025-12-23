import SwiftUI
import Observation

@Observable
class CycleTrackingViewModel {

    // MARK: - State

    var currentCycle: CycleLog?
    var isLoading: Bool = false

    // MARK: - Private Properties

    private let repository: InMemorySymptomRepository
    private let userId: UUID

    // MARK: - Computed Properties

    /// Whether user is currently on their period
    var isOnPeriod: Bool {
        currentCycle?.isOngoing ?? false
    }

    /// Number of days since period started (if ongoing)
    var daysSincePeriodStart: Int? {
        guard let cycle = currentCycle, cycle.isOngoing else { return nil }
        return Calendar.current.dateComponents([.day], from: cycle.startDate, to: Date()).day
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

    /// Loads current cycle data from repository
    func loadData() {
        isLoading = true

        // Check if there's an ongoing cycle
        currentCycle = repository.ongoingCycle(for: userId)

        isLoading = false
    }

    // MARK: - Cycle Actions

    /// Starts a new period on the given date
    /// - Parameter date: The date the period started
    func startPeriod(on date: Date) {
        // Check if already on period
        guard currentCycle == nil else {
            print("Already on period, cannot start new one")
            return
        }

        // Create new cycle log
        let newCycle = CycleLog(
            userId: userId,
            startDate: date.startOfDay,
            endDate: nil,  // ongoing
            flowHeaviness: nil,  // not set yet
            hasSpotting: false,
            crampsSeverity: nil,
            notes: nil
        )

        // Save to repository
        repository.save(cycleLog: newCycle)

        // Update local state
        currentCycle = newCycle
    }

    // TODO: Add methods for updating flow, cramps, spotting, notes
    // TODO: Add method for ending period
}
