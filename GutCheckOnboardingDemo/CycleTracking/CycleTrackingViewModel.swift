import Foundation
import SwiftUI
import Observation

@Observable
class CycleTrackingViewModel {

    // MARK: - Published State

    var currentWeekStart: Date
    var selectedDate: Date
    var weekDays: [DayColumnData] = []
    var logData: LogData

    // MARK: - Dependencies

    private let userId: UUID
    private let symptomRepository: SymptomRepositoryProtocol
    // TODO: Connect to repository - add repository dependency in future phase

    // MARK: - Initialization

    init(userId: UUID, symptomRepository: SymptomRepositoryProtocol = InMemorySymptomRepository.shared) {
        self.userId = userId
        self.symptomRepository = symptomRepository

        // Initialize to current week
        let today = Date()
        self.currentWeekStart = today.startOfWeek
        self.selectedDate = today.startOfDay

        // Initialize with empty log data
        self.logData = LogData(
            selectedDate: Self.formatDate(today),
            periodValue: nil,
            hasSpotting: false,
            symptomsPreview: nil,
            selectedSymptomIds: Set()
        )

        // Load initial data
        loadWeekData()
    }

    // MARK: - Public Methods

    /// Select a day by index (0 = Monday, 6 = Sunday)
    func selectDay(_ index: Int) {
        selectedDate = currentWeekStart.addingDays(index)
        loadWeekData()
        updateLogData()
    }

    /// Navigate to the previous week
    func navigateToPreviousWeek() {
        currentWeekStart = currentWeekStart.addingWeeks(-1)
        loadWeekData()
    }

    /// Navigate to the next week
    func navigateToNextWeek() {
        currentWeekStart = currentWeekStart.addingWeeks(1)
        loadWeekData()
    }

    /// Toggle spotting for the selected day
    func toggleSpotting(_ hasSpotting: Bool) {
        // Update the log data
        logData = LogData(
            selectedDate: logData.selectedDate,
            periodValue: logData.periodValue,
            hasSpotting: hasSpotting,
            symptomsPreview: logData.symptomsPreview,
            selectedSymptomIds: logData.selectedSymptomIds
        )

        // Update week view if there's a flow level set
        if let flowValue = logData.periodValue,
           let flowLevel = FlowLevel(rawValue: flowValue) {
            updateWeekViewForSelectedDay(flowLevel: flowLevel, hasSpotting: hasSpotting)
        }

        // TODO: Later phase - persist to repository
        // For now, just update local state
    }

    /// Update period data for the selected day
    func updatePeriodData(isTracking: Bool, flowLevel: FlowLevel?) {
        if isTracking {
            // User is tracking period with a flow level
            logData = LogData(
                selectedDate: logData.selectedDate,
                periodValue: flowLevel?.rawValue,
                hasSpotting: logData.hasSpotting,
                symptomsPreview: logData.symptomsPreview,
                selectedSymptomIds: logData.selectedSymptomIds
            )
        } else {
            // User turned off tracking - clear period data
            logData = LogData(
                selectedDate: logData.selectedDate,
                periodValue: nil,
                hasSpotting: false, // Also clear spotting when not tracking
                symptomsPreview: logData.symptomsPreview,
                selectedSymptomIds: logData.selectedSymptomIds
            )
        }

        // Update the week view to reflect the change
        updateWeekViewForSelectedDay(flowLevel: flowLevel, hasSpotting: logData.hasSpotting)

        // TODO: Later phase - persist to repository
        // For now, just update local state
    }

    /// Update symptoms data for the selected day
    func updateSymptomsData(selectedIds: Set<UUID>) {
        // Generate preview text
        let preview: String? = {
            if selectedIds.isEmpty {
                return nil
            }

            let symptomNames = selectedIds.compactMap { id in
                symptomRepository.symptom(withId: id)?.name
            }.sorted()

            if symptomNames.count == 1 {
                return symptomNames[0]
            } else if symptomNames.count == 2 {
                return "\(symptomNames[0]), \(symptomNames[1])"
            } else if symptomNames.count > 2 {
                return "\(symptomNames[0]), \(symptomNames[1]) +\(symptomNames.count - 2)"
            }

            return nil
        }()

        // Update log data
        logData = LogData(
            selectedDate: logData.selectedDate,
            periodValue: logData.periodValue,
            hasSpotting: logData.hasSpotting,
            symptomsPreview: preview,
            selectedSymptomIds: selectedIds
        )

        // TODO: Later phase - persist to repository
        // For now, just update local state
    }

    /// Load week data and generate day columns
    func loadWeekData() {
        let today = Date().startOfDay
        var days: [DayColumnData] = []

        for index in 0..<7 {
            let date = currentWeekStart.addingDays(index)

            // Generate day label (M, T, W, Th, F, Sa, Su)
            let dayLabel = Self.dayLabel(for: index)

            // Get date number (1-31)
            let calendar = Calendar.current
            let dateNumber = calendar.component(.day, from: date)

            // TODO: Connect to repository - fetch real flow data
            // For now, use mock data
            let flowData = Self.mockFlowData(for: index)

            // Check if this is today
            let isToday = date.isSameDay(as: today)

            // Check if this is selected
            let isSelected = date.isSameDay(as: selectedDate)

            days.append(DayColumnData(
                dayLabel: dayLabel,
                dateNumber: dateNumber,
                flowData: flowData,
                isToday: isToday,
                isSelected: isSelected
            ))
        }

        weekDays = days
    }

    /// Update log data for the selected date
    func updateLogData() {
        // TODO: Connect to repository - fetch real log data for selected date
        // For now, use empty state
        logData = LogData(
            selectedDate: Self.formatDate(selectedDate),
            periodValue: nil,
            hasSpotting: false,
            symptomsPreview: nil,
            selectedSymptomIds: Set()
        )
    }

    // MARK: - Computed Properties

    /// Returns formatted week range like "Jan 6 - Jan 12"
    var weekRange: String {
        let weekEnd = currentWeekStart.addingDays(6)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let startString = formatter.string(from: currentWeekStart)
        let endString = formatter.string(from: weekEnd)

        return "\(startString) - \(endString)"
    }

    // MARK: - Private Helpers

    /// Update the week view for the currently selected day
    private func updateWeekViewForSelectedDay(flowLevel: FlowLevel?, hasSpotting: Bool) {
        // Find which day index is currently selected
        guard let selectedIndex = weekDays.firstIndex(where: { $0.isSelected }) else {
            return
        }

        // Create updated flow data
        let flowData: FlowBarData? = if let flowLevel = flowLevel {
            FlowBarData(flowLevel: flowLevel, hasSpotting: hasSpotting)
        } else {
            nil
        }

        // Update that specific day in the array
        weekDays[selectedIndex] = DayColumnData(
            dayLabel: weekDays[selectedIndex].dayLabel,
            dateNumber: weekDays[selectedIndex].dateNumber,
            flowData: flowData,
            isToday: weekDays[selectedIndex].isToday,
            isSelected: true
        )
    }

    /// Format date as "Wed, Jan 8"
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }

    /// Get day label for index (0 = M, 1 = T, etc.)
    private static func dayLabel(for index: Int) -> String {
        let labels = ["M", "T", "W", "Th", "F", "Sa", "Su"]
        return labels[index]
    }

    /// Mock flow data for testing (will be replaced with repository data)
    private static func mockFlowData(for index: Int) -> FlowBarData? {
        switch index {
        case 0: // Monday
            return FlowBarData(flowLevel: .heavy, hasSpotting: false)
        case 1: // Tuesday
            return FlowBarData(flowLevel: .medium, hasSpotting: true)
        default:
            return nil
        }
    }
}
