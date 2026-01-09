import Foundation

// MARK: - Cycle Log

/// Records menstrual cycle tracking data.
/// Tracks period start/end dates, flow characteristics, and related symptoms.
/// Designed for easy backend integration - swap repository implementation when ready.
struct CycleLog: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    var startDate: Date
    var endDate: Date?             // nil if period still ongoing
    var flowHeaviness: FlowLevel?
    var hasSpotting: Bool
    var crampsSeverity: Severity?
    var notes: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        userId: UUID,
        startDate: Date,
        endDate: Date? = nil,
        flowHeaviness: FlowLevel? = nil,
        hasSpotting: Bool = false,
        crampsSeverity: Severity? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.startDate = startDate.startOfDay
        self.endDate = endDate?.startOfDay
        self.flowHeaviness = flowHeaviness
        self.hasSpotting = hasSpotting
        self.crampsSeverity = crampsSeverity
        self.notes = notes
    }
}

// MARK: - CycleLog Computed Properties

extension CycleLog {
    /// Whether this cycle is still ongoing (no end date)
    var isOngoing: Bool {
        endDate == nil
    }

    /// Duration of the period in days (nil if ongoing)
    var durationDays: Int? {
        guard let end = endDate else { return nil }
        return Calendar.current.dateComponents([.day], from: startDate, to: end).day.map { $0 + 1 }
    }

    /// Number of days in this cycle (or days so far if ongoing)
    var daysElapsed: Int {
        let end = endDate ?? Date()
        return Calendar.current.dateComponents([.day], from: startDate, to: end).day ?? 0
    }

    /// Whether this cycle includes a specific date
    func includes(date: Date) -> Bool {
        let normalizedDate = date.startOfDay
        let end = endDate ?? Date().startOfDay
        return normalizedDate >= startDate && normalizedDate <= end
    }
}

// MARK: - CycleLog Mutations

extension CycleLog {
    /// Returns a copy with the period ended on the specified date
    func endingOn(_ date: Date) -> CycleLog {
        var copy = self
        copy.endDate = date.startOfDay
        return copy
    }

    /// Returns a copy with updated flow heaviness
    func withFlowHeaviness(_ flow: FlowLevel?) -> CycleLog {
        var copy = self
        copy.flowHeaviness = flow
        return copy
    }

    /// Returns a copy with updated spotting status
    func withSpotting(_ hasSpotting: Bool) -> CycleLog {
        var copy = self
        copy.hasSpotting = hasSpotting
        return copy
    }

    /// Returns a copy with updated cramps severity
    func withCrampsSeverity(_ severity: Severity?) -> CycleLog {
        var copy = self
        copy.crampsSeverity = severity
        return copy
    }

    /// Returns a copy with updated notes
    func withNotes(_ notes: String?) -> CycleLog {
        var copy = self
        copy.notes = notes
        return copy
    }
}

// MARK: - CycleLog Factory

extension CycleLog {
    /// Creates a new cycle starting today
    static func startToday(for userId: UUID) -> CycleLog {
        CycleLog(userId: userId, startDate: Date())
    }

    /// Creates a new cycle starting on a specific date
    static func starting(on date: Date, for userId: UUID) -> CycleLog {
        CycleLog(userId: userId, startDate: date)
    }
}

// MARK: - CycleLog Array Extensions

extension Array where Element == CycleLog {
    /// Returns cycles sorted by start date (most recent first)
    func sortedByStartDate(ascending: Bool = false) -> [CycleLog] {
        sorted { ascending ? $0.startDate < $1.startDate : $0.startDate > $1.startDate }
    }

    /// Returns the most recent cycle
    var mostRecent: CycleLog? {
        sortedByStartDate().first
    }

    /// Returns any ongoing cycle (should only be one at most)
    var ongoing: CycleLog? {
        first { $0.isOngoing }
    }
}
