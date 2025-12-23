import SwiftUI

struct CycleDateScrollView: View {
    let currentCycle: CycleLog?
    let onDayTapped: (Date) -> Void

    // MARK: - Private State

    @State private var weekDays: [Date] = []
    private let today = Date()

    // MARK: - Initialization

    init(currentCycle: CycleLog?, onDayTapped: @escaping (Date) -> Void) {
        self.currentCycle = currentCycle
        self.onDayTapped = onDayTapped
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {

            // MARK: - Date Header
            Text(dateHeaderText)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.title2Tracking)

            // MARK: - Week View
            VStack(spacing: AppTheme.Spacing.xs) {

                // Day letters row
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(weekDays, id: \.self) { date in
                        Text(dayLetter(for: date))
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(
                                isToday(date)
                                    ? AppTheme.Colors.textPrimary
                                    : AppTheme.Colors.textSecondary
                            )
                            .fontWeight(isToday(date) ? .bold : .regular)
                            .frame(width: 40)
                    }
                }

                // Day circles row
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(weekDays, id: \.self) { date in
                        DayCircle(
                            date: date,
                            isToday: isToday(date),
                            isPeriodDay: isPeriodDay(date),
                            hasSpotting: false,  // TODO: Check spotting when implemented
                            onTap: { onDayTapped(date) }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
        .onAppear {
            generateWeekDays()
        }
    }

    // MARK: - Helpers

    private var dateHeaderText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return "Today, \(formatter.string(from: today))"
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

        // Get the start of the current week (Sunday)
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start else {
            weekDays = []
            return
        }

        // Generate 7 days starting from Sunday
        weekDays = (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: weekStart)
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

        // Preview with ongoing cycle
        CycleDateScrollView(
            currentCycle: CycleLog(
                userId: UUID(),
                startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
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
