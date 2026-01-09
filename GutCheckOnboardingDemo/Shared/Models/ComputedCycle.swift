import Foundation

/// Represents a computed menstrual cycle derived from daily flow logs
struct ComputedCycle: Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date?
    let periodDays: [DailyLog]

    var isOngoing: Bool {
        endDate == nil
    }

    var duration: Int {
        let end = endDate ?? Date().startOfDay
        return Calendar.current.dateComponents([.day], from: startDate, to: end).day ?? 0
    }

    var flowDays: [DailyLog] {
        periodDays.filter {
            guard let level = $0.flowLevel else { return false }
            return level.isActualFlow
        }
    }

    var flowDaysCount: Int {
        flowDays.count
    }

    init(id: UUID = UUID(), startDate: Date, endDate: Date?, days: [DailyLog]) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.periodDays = days
    }
}

/// Utilities for computing cycles from daily logs
struct CycleComputationUtilities {

    /// Groups daily logs into menstrual cycles based on period start dates
    ///
    /// **Algorithm:**
    /// - A cycle starts on the first day of period (flowLevel != nil)
    /// - A new cycle starts when there's a 14+ day gap between period days
    /// - The last cycle is ongoing (endDate = nil) until a new period starts
    ///
    /// **Example:**
    /// ```
    /// Jan 1: .heavy        → Cycle 1 starts
    /// Jan 2: .medium       → Part of Cycle 1
    /// Jan 3-27: nil        → No logging (still Cycle 1)
    /// Jan 28: .medium      → Cycle 2 starts (14+ days later)
    ///                      → Cycle 1 ends on Jan 27
    /// ```
    static func groupIntoCycles(_ dailyLogs: [DailyLog]) -> [ComputedCycle] {
        // Filter to days with period tracking (flowLevel != nil)
        let periodDays = dailyLogs
            .filter { $0.flowLevel != nil }
            .sorted { $0.date < $1.date }

        guard !periodDays.isEmpty else { return [] }

        var cycles: [ComputedCycle] = []
        var currentCycleStartDate = periodDays[0].date
        var currentCyclePeriodDays: [DailyLog] = [periodDays[0]]

        // Iterate through period days to identify cycle boundaries
        for i in 1..<periodDays.count {
            let previousDate = periodDays[i - 1].date
            let currentDate = periodDays[i].date

            let daysBetween = Calendar.current.dateComponents([.day],
                from: previousDate, to: currentDate).day ?? 0

            if daysBetween >= 14 {
                // 14+ day gap = new cycle starts
                // Close previous cycle
                let cycleEndDate = Calendar.current.date(
                    byAdding: .day,
                    value: -1,
                    to: currentDate
                )!

                cycles.append(ComputedCycle(
                    startDate: currentCycleStartDate,
                    endDate: cycleEndDate,
                    days: currentCyclePeriodDays
                ))

                // Start new cycle
                currentCycleStartDate = currentDate
                currentCyclePeriodDays = [periodDays[i]]
            } else {
                // Same cycle continues
                currentCyclePeriodDays.append(periodDays[i])
            }
        }

        // Add final cycle (ongoing - no endDate)
        cycles.append(ComputedCycle(
            startDate: currentCycleStartDate,
            endDate: nil,  // Ongoing cycle
            days: currentCyclePeriodDays
        ))

        return cycles
    }

    /// **Current cycle:** The most recent cycle that hasn't ended yet (endDate == nil)
    static func getCurrentCycle(from dailyLogs: [DailyLog]) -> ComputedCycle? {
        let cycles = groupIntoCycles(dailyLogs)

        // The last cycle is ongoing if its endDate is nil
        return cycles.last?.isOngoing == true ? cycles.last : nil
    }
}
