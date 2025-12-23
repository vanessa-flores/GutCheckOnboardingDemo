import SwiftUI

struct CycleDateScrollView: View {
    let currentCycle: CycleLog?
    let onDayTapped: (Date) -> Void

    // MARK: - Private State

    @State private var weekDays: [Date] = []
    @State private var centeredDate: Date?
    private let today = Date()

    // MARK: - Initialization

    init(currentCycle: CycleLog?, onDayTapped: @escaping (Date) -> Void) {
        self.currentCycle = currentCycle
        self.onDayTapped = onDayTapped
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {

            // MARK: - Date Header
            Text(displayedDateHeaderText)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.title2Tracking)

            // MARK: - Scrollable Date View
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(weekDays, id: \.self) { date in
                        VStack(spacing: AppTheme.Spacing.xs) {
                            // Day letter for this specific date
                            Text(dayLetter(for: date))
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(
                                    isToday(date)
                                        ? AppTheme.Colors.textPrimary
                                        : AppTheme.Colors.textSecondary
                                )
                                .fontWeight(isToday(date) ? .bold : .regular)
                                .frame(width: 40)

                            // Day circle
                            DayCircle(
                                date: date,
                                isToday: isToday(date),
                                isPeriodDay: isPeriodDay(date),
                                hasSpotting: false,
                                onTap: { onDayTapped(date) }
                            )
                            .id(date)  // Important for scrollPosition
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $centeredDate, anchor: .center)
            .contentMargins(.horizontal, edgePadding, for: .scrollContent)
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
        .onAppear {
            generateWeekDays()
            // Center on today initially
            centeredDate = today.startOfDay
        }
    }

    // MARK: - Helpers

    private var dateHeaderText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return "Today, \(formatter.string(from: today))"
    }

    /// Date header text that updates based on centered date
    private var displayedDateHeaderText: String {
        let displayDate = centeredDate ?? today
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"

        // Show "Today" if centered date is today
        if Calendar.current.isDate(displayDate, inSameDayAs: today) {
            return "Today, \(formatter.string(from: displayDate))"
        } else {
            return formatter.string(from: displayDate)
        }
    }

    /// Calculate edge padding to show ~3.5 days on each side
    private var edgePadding: CGFloat {
        let dayWidth: CGFloat = 40 + AppTheme.Spacing.sm  // circle + spacing
        let screenWidth = UIScreen.main.bounds.width
        // Show approximately 7 days total (3.5 on each side of center)
        return (screenWidth - (7 * dayWidth)) / 2
    }

    private func dayLetter(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"  // Single letter (S, M, T, etc.)
        return formatter.string(from: date).uppercased()
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: today)
    }

    private func isPeriodDay(_ date: Date) -> Bool {
        guard let cycle = currentCycle else { return false }

        // Check if date is on or after start date
        guard date >= cycle.startDate else { return false }

        // If cycle has end date, check if date is before or on end date
        if let endDate = cycle.endDate {
            return date <= endDate
        }

        // If no end date (ongoing), date is a period day if it's not in the future
        return date <= Date()
    }

    private func generateWeekDays() {
        let calendar = Calendar.current

        // Generate 45 days before today + today + 45 days after
        // Total: 91 days for scrollable range
        let daysRange = -45...45

        weekDays = daysRange.compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today.startOfDay)
        }
    }
}

// MARK: - Day Circle Component

private struct DayCircle: View {
    let date: Date
    let isToday: Bool
    let isPeriodDay: Bool
    let hasSpotting: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background circle
                Circle()
                    .fill(circleColor)
                    .frame(width: 40, height: 40)

                // Today indicator (outline)
                if isToday {
                    Circle()
                        .strokeBorder(AppTheme.Colors.primaryAction, lineWidth: 2)
                        .frame(width: 44, height: 44)
                }

                // Spotting dot (below circle)
                if hasSpotting && !isPeriodDay {
                    Circle()
                        .fill(AppTheme.Colors.warning)
                        .frame(width: 6, height: 6)
                        .offset(y: 24)
                }
            }
        }
        .frame(width: 40, height: 40)
    }

    private var circleColor: Color {
        if isPeriodDay {
            return AppTheme.Colors.error
        } else {
            return AppTheme.Colors.textSecondary.opacity(0.1)
        }
    }
}

#Preview {
    VStack {
        CycleDateScrollView(
            currentCycle: nil,
            onDayTapped: { date in
                print("Tapped date: \(date)")
            }
        )

        Spacer()

        // Preview with ongoing cycle (started 3 days ago)
        CycleDateScrollView(
            currentCycle: CycleLog(
                userId: UUID(),
                startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                endDate: nil,
                flowHeaviness: .medium,
                hasSpotting: false,
                crampsSeverity: nil,
                notes: nil
            ),
            onDayTapped: { date in
                print("Tapped date: \(date)")
            }
        )
    }
    .background(AppTheme.Colors.background)
}
