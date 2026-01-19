import Foundation

// MARK: - Date Normalization

extension Date {
    /// Returns the start of the day (midnight) for this date.
    /// Used for consistent date comparisons across the app.
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Returns the end of the day (23:59:59) for this date.
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }

    /// Returns the start of the week (Monday) for this date.
    /// Used for week-based views and cycle tracking.
    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Monday (1 = Sunday, 2 = Monday, per ISO 8601)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}

// MARK: - Date Comparisons

extension Date {
    /// Whether this date is the same calendar day as another date
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    /// Whether this date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Whether this date is yesterday
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Whether this date is in the current week
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// Whether this date is in the current month
    var isThisMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
}

// MARK: - Date Arithmetic

extension Date {
    /// Returns a date by adding/subtracting days
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Returns a date by adding/subtracting weeks
    func addingWeeks(_ weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self) ?? self
    }

    /// Returns a date by adding/subtracting months
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    /// Number of days between this date and another
    func daysBetween(_ other: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self.startOfDay, to: other.startOfDay)
        return components.day ?? 0
    }
}

// MARK: - Date Range Generation

extension Date {
    /// Generates an array of dates from this date to the end date (inclusive)
    func datesThrough(_ endDate: Date) -> [Date] {
        var dates: [Date] = []
        var current = self.startOfDay
        let end = endDate.startOfDay

        while current <= end {
            dates.append(current)
            current = current.addingDays(1)
        }

        return dates
    }

    /// Returns the last N days including today
    static func lastDays(_ count: Int) -> [Date] {
        let today = Date().startOfDay
        return (0..<count).map { today.addingDays(-$0) }.reversed()
    }
}
