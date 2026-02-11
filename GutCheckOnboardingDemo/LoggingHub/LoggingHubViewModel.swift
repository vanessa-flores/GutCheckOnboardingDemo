import Foundation
import SwiftUI
import Observation

// MARK: - Active Modal

enum ActiveModal: String, Identifiable {
    case todaysCheckIn
    case cycleLog

    var id: String { rawValue }
}

// MARK: - LoggingHubViewModel

@Observable
class LoggingHubViewModel {

    // MARK: - Dependencies

    let userId: UUID
    private let repository: DailyLogRepositoryProtocol
    private let symptomCatalog: SymptomCatalogProtocol

    // MARK: - Week State

    var currentWeekStart: Date
    var selectedDate: Date
    var weekDays: [DayColumnData] = []

    // MARK: - Modal State

    var activeModal: ActiveModal? = nil

    // MARK: - Snapshot State

    var snapshotData: DailySnapshotDisplayData = .empty

    // MARK: - Computed Properties (Week-Related)

    var isSelectedDateToday: Bool {
        selectedDate.isSameDay(as: Date())
    }

    var isSelectedDateYesterday: Bool {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return false }
        return selectedDate.isSameDay(as: yesterday)
    }

    var isSelectedDateInFuture: Bool {
        selectedDate > Date().startOfDay
    }

    /// "Jan 6 - Jan 12"
    var weekRange: String {
        let weekEnd = currentWeekStart.addingDays(6)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: currentWeekStart)) - \(formatter.string(from: weekEnd))"
    }

    /// "Log Today", "Log Yesterday", "Log Tuesday", "Log Tue, Jan 28", or "Log Tue, Jan 28, 2025"
    var sectionHeaderText: String {
        if isSelectedDateToday {
            return "Log Today"
        } else if isSelectedDateYesterday {
            return "Log Yesterday"
        } else {
            let today = Date()
            let calendar = Calendar.current
            let isInCurrentWeek = calendar.isDate(selectedDate, equalTo: today, toGranularity: .weekOfYear)

            if isInCurrentWeek {
                // Same week: "Log Tuesday"
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                return "Log \(formatter.string(from: selectedDate))"
            } else {
                // Different week: check if same year
                let selectedYear = calendar.component(.year, from: selectedDate)
                let currentYear = calendar.component(.year, from: today)

                let formatter = DateFormatter()
                if selectedYear == currentYear {
                    // Same year: "Log Tue, Jan 28"
                    formatter.dateFormat = "EEE, MMM d"
                } else {
                    // Different year: "Log Tue, Jan 28, 2025"
                    formatter.dateFormat = "EEE, MMM d, yyyy"
                }
                return "Log \(formatter.string(from: selectedDate))"
            }
        }
    }

    let checkInCardTitle = "Daily check-in"

    // MARK: - Computed Properties (Selected Date Data)

    /// Flow level for selected date
    var selectedDateFlowLevel: FlowLevel? {
        repository.dailyLog(for: userId, on: selectedDate)?.flowLevel
    }

    /// Symptom IDs for selected date
    var selectedDateSymptomIds: Set<UUID> {
        let dailyLog = repository.dailyLog(for: userId, on: selectedDate)
        let ids = dailyLog?.symptomLogs.map { $0.symptomId } ?? []
        return Set(ids)
    }

    // MARK: - Initialization

    init(
        userId: UUID,
        repository: DailyLogRepositoryProtocol = InMemorySymptomRepository.shared,
        symptomCatalog: SymptomCatalogProtocol = InMemorySymptomRepository.shared
    ) {
        self.userId = userId
        self.repository = repository
        self.symptomCatalog = symptomCatalog
        self.currentWeekStart = Date().startOfWeek
        self.selectedDate = Date().startOfDay
        loadWeekData()
        loadSnapshotData()
    }

    // MARK: - Week Navigation

    /// Selects a specific day in the current week
    /// - Parameter index: Day index (0 = Monday, 6 = Sunday)
    func selectDay(_ index: Int) {
        let date = currentWeekStart.addingDays(index)
        guard date <= Date().startOfDay else { return }  // Prevent future selection
        selectedDate = date
        loadWeekData()
        loadSnapshotData()
    }

    /// Moves the week view backward by 7 days and reloads data
    func navigateToPreviousWeek() {
        currentWeekStart = currentWeekStart.addingWeeks(-1)
        // Select last day of week or today, whichever is earlier
        let lastDayOfWeek = currentWeekStart.addingDays(6)
        let today = Date().startOfDay
        selectedDate = min(lastDayOfWeek, today)
        loadWeekData()
        loadSnapshotData()
    }

    /// Moves the week view forward by 7 days and reloads data
    func navigateToNextWeek() {
        let nextWeekStart = currentWeekStart.addingWeeks(1)
        let today = Date().startOfDay

        // Prevent navigating to all-future weeks
        guard nextWeekStart <= today else { return }

        currentWeekStart = nextWeekStart
        let lastDayOfWeek = currentWeekStart.addingDays(6)
        selectedDate = min(lastDayOfWeek, today)
        loadWeekData()
        loadSnapshotData()
    }

    func refreshData() {
        loadWeekData()
        loadSnapshotData()
    }

    // MARK: - Modal Actions

    func showCycleLogModal() {
        guard !isSelectedDateInFuture else { return }
        activeModal = .cycleLog
    }

    func showCheckInModal() {
        guard !isSelectedDateInFuture else { return }
        activeModal = .todaysCheckIn
    }

    func dismissModal() {
        activeModal = nil
    }

    // MARK: - Save Actions

    func saveCycleData(isTracking: Bool, flowLevel: FlowLevel?, symptomIds: Set<UUID>) {
        var dailyLog = repository.dailyLog(for: userId, on: selectedDate)
            ?? DailyLog(userId: userId, date: selectedDate)

        // Update flow
        dailyLog.flowLevel = isTracking ? flowLevel : nil

        // Update symptoms - clear and rebuild
        dailyLog.symptomLogs.removeAll()
        for symptomId in symptomIds {
            let symptomLog = SymptomLog(
                userId: userId,
                symptomId: symptomId,
                date: selectedDate
            )
            dailyLog = dailyLog.addingSymptomLog(symptomLog)
        }

        repository.save(dailyLog: dailyLog)
        refreshData()
    }

    // MARK: - Private Methods

    /// Load week data and generate day columns
    private func loadWeekData() {
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
    }

    /// Get day label for index (0 = M, 1 = T, etc.)
    private static func dayLabel(for index: Int) -> String {
        let labels = ["M", "T", "W", "Th", "F", "Sa", "Su"]
        return labels[index]
    }

    private func loadSnapshotData() {
        guard let dailyLog = repository.dailyLog(for: userId, on: selectedDate) else {
            snapshotData = .empty
            return
        }

        let moodEmoji = dailyLog.mood?.emoji
        let moodLabel = dailyLog.mood?.displayName

        let symptomNames = dailyLog.symptomLogs.compactMap { symptomLog -> String? in
            guard let symptom = symptomCatalog.symptom(withId: symptomLog.symptomId) else { return nil }
            return symptom.name.lowercased()
        }

        let flowLabel: String? = {
            guard let flowLevel = dailyLog.flowLevel else { return nil }
            if flowLevel == .none {
                return "No flow"
            }
            return flowLevel.description
        }()

        snapshotData = DailySnapshotDisplayData(
            moodEmoji: moodEmoji,
            moodLabel: moodLabel,
            symptomNames: symptomNames,
            flowLabel: flowLabel
        )
    }
}
