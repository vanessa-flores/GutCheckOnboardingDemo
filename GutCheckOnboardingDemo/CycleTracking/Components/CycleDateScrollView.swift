import SwiftUI

struct CycleDateScrollView: View {
    let currentCycle: CycleLog?
    let onDayTapped: (Date) -> Void

    // MARK: - Layout Constants

    fileprivate enum Layout {
        // Day sizing
        static let dayCircleSize: CGFloat = 44
        static let todayCircleSize: CGFloat = 20
        static let daySpacing: CGFloat = 4
        static let visibleDays: CGFloat = 7.0
        static let centeredDayScale: CGFloat = 1.2

        // Day letter section
        static let dayLetterMinWidth: CGFloat = 26
        static let dayLetterSpacing: CGFloat = AppTheme.Spacing.sm

        // Spotting indicator
        static let spottingDotSize: CGFloat = 6
        static let spottingDotOffset: CGFloat = 24

        // Separator
        static let separatorHeight: CGFloat = 1
        static let triangleOffset: CGFloat = 1

        // Triangle
        static let triangleSize: CGFloat = 12

        // Computed: maximum day size when scaled
        static var maxDaySize: CGFloat {
            dayCircleSize * centeredDayScale
        }
    }

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
        VStack(spacing: AppTheme.Spacing.xs) {

            // MARK: - Date Header
            Text(displayedDateHeaderText)
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.title2Tracking)
                .padding(.horizontal, AppTheme.Spacing.xl)


            // MARK: - Separator with Center Indicator
            DateSeparatorWithIndicator()

            // MARK: - Scrollable Date View
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.daySpacing) {
                    ForEach(weekDays, id: \.self) { date in
                        DayItemView(
                            date: date,
                            isToday: isToday(date),
                            isPeriodDay: isPeriodDay(date),
                            hasSpotting: false,
                            isCentered: isCenteredDate(date),
                            onTap: { onDayTapped(date) }
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $centeredDate, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, edgePadding, for: .scrollContent)
        }
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
        .onAppear {
            generateWeekDays()
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

        // Show "Today" if centered date is today
        if Calendar.current.isDate(displayDate, inSameDayAs: today) {
            formatter.dateFormat = "MMMM d"
            return "Today, \(formatter.string(from: displayDate))"
        } else {
            formatter.dateFormat = "EEEE, MMMM d"
            return formatter.string(from: displayDate)
        }
    }

    /// Calculate edge padding accounting for scaled centered day
    private var edgePadding: CGFloat {
        // Account for maximum possible size (when centered and scaled)
        let maxDaySize = Layout.maxDaySize

        // Total width = (number of days × max day width) + (spacing gaps between days)
        let totalContentWidth = (Layout.visibleDays * maxDaySize) +
                               ((Layout.visibleDays - 1) * Layout.daySpacing)

        let screenWidth = UIScreen.main.bounds.width
        let calculatedPadding = (screenWidth - totalContentWidth) / 2

        return max(calculatedPadding, 0)  // Ensure non-negative padding
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

    private func isCenteredDate(_ date: Date) -> Bool {
        guard let centered = centeredDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: centered)
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
    let isCentered: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background circle
                Circle()
                    .fill(circleColor)
                    .frame(width: CycleDateScrollView.Layout.dayCircleSize - 4,
                           height: CycleDateScrollView.Layout.dayCircleSize - 4)

                // Spotting dot (below circle)
                if hasSpotting && !isPeriodDay {
                    Circle()
                        .fill(AppTheme.Colors.warning)
                        .frame(width: CycleDateScrollView.Layout.spottingDotSize,
                               height: CycleDateScrollView.Layout.spottingDotSize)
                        .offset(y: CycleDateScrollView.Layout.spottingDotOffset)
                }
            }
            .scaleEffect(isCentered ? CycleDateScrollView.Layout.centeredDayScale : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isCentered)
            .frame(
                width: CycleDateScrollView.Layout.maxDaySize,
                height: CycleDateScrollView.Layout.maxDaySize,
                alignment: .center
            )
        }
        .buttonStyle(.plain)
        .frame(
            width: CycleDateScrollView.Layout.maxDaySize,
            height: CycleDateScrollView.Layout.maxDaySize
        )
    }

    private var circleColor: Color {
        if isPeriodDay {
            return AppTheme.Colors.error
        } else {
            return AppTheme.Colors.textSecondary.opacity(0.1)
        }
    }
}

// MARK: - Day Letter Component

private struct DayLetterView: View {
    let date: Date
    let isToday: Bool

    var body: some View {
        ZStack {
            // Circle background for today
            if isToday {
                Circle()
                    .fill(AppTheme.Colors.textPrimary)
                    .frame(width: CycleDateScrollView.Layout.todayCircleSize,
                           height: CycleDateScrollView.Layout.todayCircleSize)
            }

            Text(dayLetter)
                .font(AppTheme.Typography.caption2)
                .foregroundColor(
                    isToday
                        ? AppTheme.Colors.background
                        : AppTheme.Colors.textSecondary
                )
                .fontWeight(isToday ? .bold : .regular)
                .frame(minWidth: CycleDateScrollView.Layout.dayLetterMinWidth)
        }
    }

    private var dayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"  // Single letter
        return formatter.string(from: date).uppercased()
    }
}

// MARK: - Day Item Component

private struct DayItemView: View {
    let date: Date
    let isToday: Bool
    let isPeriodDay: Bool
    let hasSpotting: Bool
    let isCentered: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: CycleDateScrollView.Layout.dayLetterSpacing) {
            DayLetterView(date: date, isToday: isToday)

            DayCircle(
                date: date,
                isToday: isToday,
                isPeriodDay: isPeriodDay,
                hasSpotting: hasSpotting,
                isCentered: isCentered,
                onTap: onTap
            )
        }
        .frame(width: CycleDateScrollView.Layout.maxDaySize)
        .id(date)
    }
}

// MARK: - Date Separator with Indicator

private struct DateSeparatorWithIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(AppTheme.Colors.textSecondary.opacity(0.2))
                .frame(height: CycleDateScrollView.Layout.separatorHeight)

            HStack {
                Spacer()
                Image(systemName: "triangleshape.fill")
                    .font(.system(size: CycleDateScrollView.Layout.triangleSize))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .offset(y: CycleDateScrollView.Layout.triangleOffset)
                    .rotationEffect(.degrees(180))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
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
