import Foundation

// MARK: - Cycle Insights Utilities

/// Utilities for computing cycle insights from daily logs and symptoms
struct CycleInsightsUtilities {

    // MARK: - Main Computation

    /// Computes cycle insights for a user based on their daily logs and symptoms
    /// - Parameters:
    ///   - userId: The user's ID
    ///   - repository: Combined repository providing daily logs and symptom data
    /// - Returns: CycleInsights if sufficient data exists, nil otherwise
    static func computeInsights(
        for userId: UUID,
        using repository: any DailyLogRepositoryProtocol & SymptomRepositoryProtocol
    ) -> CycleInsights? {
        // 1. Get all daily logs for the user
        let dailyLogs = repository.dailyLogs(for: userId)
        guard !dailyLogs.isEmpty else { return nil }

        // 2. Use CycleComputationUtilities to get computed cycles
        let cycles = CycleComputationUtilities.groupIntoCycles(dailyLogs)
        guard !cycles.isEmpty else { return nil }

        // 3. Calculate current cycle day
        guard let currentCycle = cycles.last, currentCycle.isOngoing else { return nil }
        let currentCycleDay = Calendar.current.dateComponents(
            [.day],
            from: currentCycle.startDate,
            to: Date().startOfDay
        ).day ?? 0

        // 4. Get last 3 completed cycles' lengths and period lengths
        let completedCycles = cycles.filter { !$0.isOngoing }
        let last3CompletedCycles = Array(completedCycles.suffix(3))

        let recentCycleLengths = last3CompletedCycles.compactMap { cycle -> Int? in
            guard let endDate = cycle.endDate else { return nil }
            let days = Calendar.current.dateComponents([.day], from: cycle.startDate, to: endDate).day ?? 0
            return days + 1 // +1 to include both start and end date
        }

        let recentPeriodLengths = last3CompletedCycles.map { $0.flowDaysCount }

        // 5. Analyze symptoms logged 1-5 days before each period start
        let warningSignsData = analyzePeriodWarnings(
            cycles: last3CompletedCycles,
            dailyLogs: dailyLogs,
            repository: repository
        )

        return CycleInsights(
            currentCycleDay: currentCycleDay,
            recentCycleLengths: recentCycleLengths,
            recentPeriodLengths: recentPeriodLengths,
            periodWarningSignsOptional: warningSignsData.isEmpty ? nil : warningSignsData
        )
    }

    // MARK: - Period Warning Analysis
    
    /// Data structure to track symptom occurrences across cycles
    private struct SymptomOccurrence {
        var totalCount: Int = 0
        var cyclesWithOccurrence: Set<UUID> = []
        var daysBeforeValues: [Int] = [] // e.g., [2, 3, 2] for "2-3 days before"
    }

    /// Analyzes symptoms that occur 1-5 days before period start across multiple cycles
    private static func analyzePeriodWarnings(
        cycles: [ComputedCycle],
        dailyLogs: [DailyLog],
        repository: any SymptomRepositoryProtocol
    ) -> [PeriodWarningSign] {
        guard cycles.count >= 1 else { return [] }

        var symptomTracking: [UUID: SymptomOccurrence] = [:]

        // For each cycle, analyze symptoms 1-5 days before period start
        for cycle in cycles {
            let periodStartDate = cycle.startDate

            // Get dates 1-5 days before period start
            for daysBefore in 1...5 {
                guard let targetDate = Calendar.current.date(
                    byAdding: .day,
                    value: -daysBefore,
                    to: periodStartDate
                ) else { continue }

                // Find daily log for this date
                if let dailyLog = dailyLogs.first(where: { $0.date == targetDate.startOfDay }) {
                    // Record each symptom found
                    for symptomLog in dailyLog.symptomLogs {
                        var occurrence = symptomTracking[symptomLog.symptomId] ?? SymptomOccurrence()
                        occurrence.totalCount += 1
                        occurrence.cyclesWithOccurrence.insert(cycle.id)
                        occurrence.daysBeforeValues.append(daysBefore)
                        symptomTracking[symptomLog.symptomId] = occurrence
                    }
                }
            }
        }

        // Convert to PeriodWarningSigns and sort by frequency
        let warningSignsCandidates = symptomTracking.compactMap { (symptomId, occurrence) -> (PeriodWarningSign, Int)? in
            guard let symptom = repository.symptom(withId: symptomId) else { return nil }

            // Calculate timing range
            let daysBeforeRange = calculateDaysBeforeRange(occurrence.daysBeforeValues)

            // Calculate frequency string (only if 2+ cycles)
            let frequencyString: String?
            if cycles.count >= 2 {
                let cycleCount = occurrence.cyclesWithOccurrence.count
                frequencyString = "In \(cycleCount) of \(cycles.count) cycles"
            } else {
                frequencyString = nil
            }

            let warningSign = PeriodWarningSign(
                symptomName: symptom.name,
                daysBeforeRange: daysBeforeRange,
                frequencyString: frequencyString
            )

            return (warningSign, occurrence.totalCount)
        }

        // Sort by frequency (total count) and return top 5
        let top5 = warningSignsCandidates
            .sorted { $0.1 > $1.1 } // Sort by count descending
            .prefix(5)
            .map { $0.0 }

        return Array(top5)
    }

    // MARK: - Helper Methods

    /// Calculates the "days before" range string from an array of day values
    /// - Parameter daysBeforeValues: Array of days before period (e.g., [2, 3, 2, 4])
    /// - Returns: Formatted string like "2-4 days before" or "3 days before"
    private static func calculateDaysBeforeRange(_ daysBeforeValues: [Int]) -> String {
        guard !daysBeforeValues.isEmpty else { return "Before period" }

        let min = daysBeforeValues.min() ?? 1
        let max = daysBeforeValues.max() ?? 5

        if min == max {
            return "\(min) day\(min == 1 ? "" : "s") before"
        } else {
            return "\(min)-\(max) days before"
        }
    }
}
