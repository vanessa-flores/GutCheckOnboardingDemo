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
    var cycleInsights: CycleInsights?

    /// Whether the currently selected date is in the future
    var isSelectedDateInFuture: Bool {
        selectedDate > Date().startOfDay
    }

    // MARK: - Dependencies

    private let userId: UUID
    private let repository: DailyLogRepositoryProtocol & SymptomRepositoryProtocol
    // DEMO NOTE: Repository is injected via init. Production version will use Supabase repository

    // MARK: - Initialization

    init(userId: UUID, repository: (DailyLogRepositoryProtocol & SymptomRepositoryProtocol) = InMemorySymptomRepository.shared) {
        self.userId = userId
        self.repository = repository

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
            selectedSymptomIds: Set(),
            isFuture: false
        )

        // Load initial data
        loadWeekData()
    }

    // MARK: - Public Methods

    /// Selects a specific day in the current week and updates the log data
    /// - Parameter index: Day index (0 = Monday, 6 = Sunday)
    func selectDay(_ index: Int) {
        selectedDate = currentWeekStart.addingDays(index)
        loadWeekData()
        updateLogData()
    }

    /// Moves the week view backward by 7 days and reloads data
    /// Automatically selects Monday (first day) of the new week
    func navigateToPreviousWeek() {
        currentWeekStart = currentWeekStart.addingWeeks(-1)
        selectedDate = currentWeekStart  // Auto-select Monday
        loadWeekData()
        updateLogData()
    }

    /// Moves the week view forward by 7 days and reloads data
    /// Automatically selects Monday (first day) of the new week
    func navigateToNextWeek() {
        currentWeekStart = currentWeekStart.addingWeeks(1)
        selectedDate = currentWeekStart  // Auto-select Monday
        loadWeekData()
        updateLogData()
    }

    /// Updates spotting status for the currently selected day
    /// - Parameter hasSpotting: Whether spotting occurred
    func toggleSpotting(_ hasSpotting: Bool) {
        // Update the log data
        logData = LogData(
            selectedDate: logData.selectedDate,
            periodValue: logData.periodValue,
            hasSpotting: hasSpotting,
            symptomsPreview: logData.symptomsPreview,
            selectedSymptomIds: logData.selectedSymptomIds,
            isFuture: isSelectedDateInFuture
        )

        // Update week view if there's a flow level set
        if let flowValue = logData.periodValue,
           let flowLevel = FlowLevel(rawValue: flowValue) {
            updateWeekViewForSelectedDay(flowLevel: flowLevel, hasSpotting: hasSpotting)
        }

        // PERSIST TO REPOSITORY
        var dailyLog = repository.dailyLog(for: userId, on: selectedDate) ?? DailyLog(
            userId: userId,
            date: selectedDate
        )

        dailyLog.hadSpotting = hasSpotting
        repository.save(dailyLog: dailyLog)
    }

    /// Update period data for the selected day
    func updatePeriodData(isTracking: Bool, flowLevel: FlowLevel?) {
        // Don't allow logging period data for future dates
        guard !isSelectedDateInFuture else { return }

        if isTracking {
            // User is tracking period with a flow level
            logData = LogData(
                selectedDate: logData.selectedDate,
                periodValue: flowLevel?.rawValue,
                hasSpotting: logData.hasSpotting,
                symptomsPreview: logData.symptomsPreview,
                selectedSymptomIds: logData.selectedSymptomIds,
                isFuture: isSelectedDateInFuture
            )
        } else {
            // User turned off tracking - clear period data
            logData = LogData(
                selectedDate: logData.selectedDate,
                periodValue: nil,
                hasSpotting: false, // Also clear spotting when not tracking
                symptomsPreview: logData.symptomsPreview,
                selectedSymptomIds: logData.selectedSymptomIds,
                isFuture: isSelectedDateInFuture
            )
        }

        // Update the week view to reflect the change
        updateWeekViewForSelectedDay(flowLevel: flowLevel, hasSpotting: logData.hasSpotting)

        // PERSIST TO REPOSITORY
        var dailyLog = repository.dailyLog(for: userId, on: selectedDate) ?? DailyLog(
            userId: userId,
            date: selectedDate
        )

        // Update flow level and spotting
        dailyLog.flowLevel = isTracking ? flowLevel : nil
        dailyLog.hadSpotting = isTracking ? logData.hasSpotting : false

        // Save to repository
        repository.save(dailyLog: dailyLog)
    }

    /// Update symptoms data for the selected day
    func updateSymptomsData(selectedIds: Set<UUID>) {
        // Generate preview text
        let preview: String? = {
            if selectedIds.isEmpty {
                return nil
            }

            let symptomNames = selectedIds.compactMap { id in
                repository.symptom(withId: id)?.name
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
            selectedSymptomIds: selectedIds,
            isFuture: isSelectedDateInFuture
        )

        // PERSIST TO REPOSITORY
        var dailyLog = repository.dailyLog(for: userId, on: selectedDate) ?? DailyLog(
            userId: userId,
            date: selectedDate
        )

        // Remove all existing symptom logs for this date
        dailyLog.symptomLogs.removeAll()

        // Add new symptom logs
        for symptomId in selectedIds {
            let symptomLog = SymptomLog(
                userId: userId,
                symptomId: symptomId,
                date: selectedDate,
                severity: nil
            )
            dailyLog = dailyLog.addingSymptomLog(symptomLog)
        }

        repository.save(dailyLog: dailyLog)
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

            // Fetch flow data from repository
            let dailyLog = repository.dailyLog(for: userId, on: date)
            let flowData: FlowBarData? = {
                guard let flowLevel = dailyLog?.flowLevel else { return nil }
                return FlowBarData(flowLevel: flowLevel, hasSpotting: dailyLog?.hadSpotting ?? false)
            }()

            // Check if this is today
            let isToday = date.isSameDay(as: today)

            // Check if this is selected
            let isSelected = date.isSameDay(as: selectedDate)

            // Check if this date is in the future
            let isFuture = date > today

            days.append(DayColumnData(
                dayLabel: dayLabel,
                dateNumber: dateNumber,
                flowData: flowData,
                isToday: isToday,
                isSelected: isSelected,
                isFuture: isFuture
            ))
        }

        weekDays = days

        computeInsights()
    }

    /// Update log data for the selected date
    func updateLogData() {
        // Fetch daily log from repository for selected date
        let dailyLog = repository.dailyLog(for: userId, on: selectedDate)

        // Extract period data
        let periodValue = dailyLog?.flowLevel?.rawValue
        let hasSpotting = dailyLog?.hadSpotting ?? false

        // Extract symptoms data
        let symptomLogs = dailyLog?.symptomLogs ?? []
        let symptomsPreview = generateSymptomsPreview(from: symptomLogs)
        let selectedIds = Set(symptomLogs.map { $0.symptomId })

        logData = LogData(
            selectedDate: Self.formatDate(selectedDate),
            periodValue: periodValue,
            hasSpotting: hasSpotting,
            symptomsPreview: symptomsPreview,
            selectedSymptomIds: selectedIds,
            isFuture: isSelectedDateInFuture
        )
    }

    /// Generates symptoms preview text from symptom logs
    private func generateSymptomsPreview(from logs: [SymptomLog]) -> String? {
        guard !logs.isEmpty else { return nil }

        let symptomNames = logs.compactMap { log in
            repository.symptom(withId: log.symptomId)?.name
        }.sorted()

        if symptomNames.count == 1 {
            return symptomNames[0]
        } else if symptomNames.count == 2 {
            return "\(symptomNames[0]), \(symptomNames[1])"
        } else if symptomNames.count > 2 {
            return "\(symptomNames[0]), \(symptomNames[1]) +\(symptomNames.count - 2)"
        }

        return nil
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

    private func computeInsights() {
        cycleInsights = CycleInsightsUtilities.computeInsights(
            for: userId,
            using: repository
        )
    }

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
            isSelected: true,
            isFuture: isSelectedDateInFuture
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

}
