import Foundation

// MARK: - Cycle Insights

/// Represents insights about menstrual cycle patterns and warning signs
struct CycleInsights: Identifiable, Codable {
    let id: UUID
    let currentCycleDay: Int
    let recentCycleLengths: [Int]
    let recentPeriodLengths: [Int]
    let periodWarningSignsOptional: [PeriodWarningSign]?

    var hasWarningSignsData: Bool {
        guard let signs = periodWarningSignsOptional else { return false }
        return !signs.isEmpty
    }

    var averageCycleLength: Double? {
        guard !recentCycleLengths.isEmpty else { return nil }
        return Double(recentCycleLengths.reduce(0, +)) / Double(recentCycleLengths.count)
    }

    var averagePeriodLength: Double? {
        guard !recentPeriodLengths.isEmpty else { return nil }
        return Double(recentPeriodLengths.reduce(0, +)) / Double(recentPeriodLengths.count)
    }

    var cycleLengthVariability: String {
        guard recentCycleLengths.count >= 2 else { return "Not enough data" }
        let min = recentCycleLengths.min() ?? 0
        let max = recentCycleLengths.max() ?? 0
        let range = max - min

        if range <= 3 {
            return "Very consistent"
        } else if range <= 7 {
            return "Moderately consistent"
        } else {
            return "Variable"
        }
    }

    init(
        id: UUID = UUID(),
        currentCycleDay: Int,
        recentCycleLengths: [Int],
        recentPeriodLengths: [Int],
        periodWarningSignsOptional: [PeriodWarningSign]? = nil
    ) {
        self.id = id
        self.currentCycleDay = currentCycleDay
        self.recentCycleLengths = recentCycleLengths
        self.recentPeriodLengths = recentPeriodLengths
        self.periodWarningSignsOptional = periodWarningSignsOptional
    }
}

// MARK: - Period Warning Sign

/// Represents a symptom that appears before period onset
struct PeriodWarningSign: Identifiable, Codable {
    let id: UUID
    let symptomName: String
    let daysBeforeRange: String

    init(
        id: UUID = UUID(),
        symptomName: String,
        daysBeforeRange: String
    ) {
        self.id = id
        self.symptomName = symptomName
        self.daysBeforeRange = daysBeforeRange
    }
}
