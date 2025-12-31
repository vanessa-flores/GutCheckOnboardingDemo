import SwiftUI
import Observation

@Observable
class CycleTrackingViewModel {

    // MARK: - Dependencies

    private let userId: UUID
    private let repository: SymptomRepositoryProtocol & DailyLogRepositoryProtocol

    // MARK: - State

    var selectedDate: Date = Date().startOfDay {
        didSet {
            logSectionViewModel.selectedDate = selectedDate
            loadData()
        }
    }

    var currentCycle: ComputedCycle?
    var cycleHistory: [ComputedCycle] = []

    // MARK: - Child ViewModels

    let logSectionViewModel: CycleLoggingViewModel

    // MARK: - Initialization

    init(userId: UUID, repository: SymptomRepositoryProtocol & DailyLogRepositoryProtocol = InMemorySymptomRepository.shared) {
        self.userId = userId
        self.repository = repository
        self.logSectionViewModel = CycleLoggingViewModel(
            userId: userId,
            selectedDate: Date().startOfDay,
            repository: repository
        )

        loadData()
    }

    // MARK: - Data Loading

    func loadData() {
        let allLogs = repository.dailyLogs(for: userId)

        let computedCycles = CycleComputationUtilities.groupIntoCycles(allLogs)
        cycleHistory = computedCycles

        currentCycle = CycleComputationUtilities.getCurrentCycle(from: allLogs)
    }
}
