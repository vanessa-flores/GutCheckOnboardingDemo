import Foundation

/// Represents a computed menstrual cycle derived from daily flow logs
struct ComputedCycle: Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let periodDays: [DailyLog]

    var duration: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1
    }

    var flowDays: [DailyLog] {
        periodDays.filter { $0.flowLevel != nil && $0.flowLevel != FlowLevel.none }
    }

    var flowDaysCount: Int {
        flowDays.count
    }

    init(id: UUID = UUID(), startDate: Date, endDate: Date, days: [DailyLog]) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.periodDays = days
    }
}

/// Utilities for computing cycles from daily logs
struct CycleComputationUtilities {

    /// Groups daily logs into cycles based on consecutive flow tracking
    ///
    /// **Rule:** Cycle = consecutive days with flowLevel != nil (including .none)
    /// Broken by 3+ days of nil (no logging)
    ///
    /// **Example:**
    /// ```
    /// Dec 1: .heavy
    /// Dec 2: .medium
    /// Dec 3: .none      ← Still part of cycle
    /// Dec 4: .none      ← Still part of cycle
    /// Dec 5: nil        ← Gap day 1
    /// Dec 6: nil        ← Gap day 2
    /// Dec 7: nil        ← Gap day 3 → Cycle ends on Dec 4
    /// Dec 8: .medium    ← New cycle starts
    /// ```
    static func groupIntoCycles(_ dailyLogs: [DailyLog]) -> [ComputedCycle] {
        // Get all days where period was logged (including "no flow")
        let periodDays = dailyLogs
            .filter { $0.flowLevel != nil }
            .sorted { $0.date < $1.date }

        guard !periodDays.isEmpty else { return [] }

        var cycles: [ComputedCycle] = []
        var currentCycleStart = periodDays[0].date
        var currentCycleDays: [DailyLog] = [periodDays[0]]

        for i in 1..<periodDays.count {
            let previousDate = periodDays[i - 1].date
            let currentDate = periodDays[i].date
            let daysBetween = Calendar.current.dateComponents([.day],
                from: previousDate, to: currentDate).day ?? 0

            if daysBetween > 3 {
                // Gap of 3+ days (no logging) = new cycle
                cycles.append(ComputedCycle(
                    startDate: currentCycleStart,
                    endDate: previousDate,
                    days: currentCycleDays
                ))

                // Start new cycle
                currentCycleStart = currentDate
                currentCycleDays = [periodDays[i]]
            } else {
                // Continue current cycle (includes 1-2 day gaps)
                currentCycleDays.append(periodDays[i])
            }
        }

        // Add final cycle (ongoing or completed)
        cycles.append(ComputedCycle(
            startDate: currentCycleStart,
            endDate: periodDays.last!.date,
            days: currentCycleDays
        ))

        return cycles
    }

    /// Gets the current active cycle (if any)
    ///
    /// **Active cycle:** Most recent period day is within 3 days of today
    static func getCurrentCycle(from dailyLogs: [DailyLog]) -> ComputedCycle? {
        let cycles = groupIntoCycles(dailyLogs)
        guard let mostRecentCycle = cycles.last else { return nil }

        let today = Date().startOfDay
        let daysSinceLastLog = Calendar.current.dateComponents([.day],
            from: mostRecentCycle.endDate, to: today).day ?? 0

        return daysSinceLastLog <= 3 ? mostRecentCycle : nil
    }
}
