import SwiftUI

struct CycleWeekScrollView: View {
    let currentCycle: CycleLog?
    let onDayTapped: (Date) -> Void

    // MARK: - State

    @State private var centeredDate: Date?
    @State private var weekDays: [Date] = []
    private let today = Date()
    private let screenWidth = UIScreen.main.bounds.width

    private var edgePadding: CGFloat {
        Layout.calculateEdgePadding(screenWidth: screenWidth)
    }

    // MARK: - Layout Constants

    fileprivate enum Layout {
        static let separatorHeight: CGFloat = 1
        static let triangleSize: CGFloat = 12
        static let triangleOffset: CGFloat = 1

        // Day item sizing
        static let itemSpacing: CGFloat = 4
        static let itemWidth: CGFloat = 48
        static let itemHeightToWidthRatio: CGFloat = 1.2

        // Computed
        static var itemHeight: CGFloat {
            itemWidth * itemHeightToWidthRatio
        }

        static var cornerRadius: CGFloat {
            itemWidth / 2  // Half width for pill shape
        }

        // Focused scaling
        static let focusedHeightScale: CGFloat = 1.3

        static var focusedItemHeight: CGFloat {
            itemHeight * focusedHeightScale
        }

        // Day letter sizing
        static let dayLetterMinWidth: CGFloat = 26
        static let todayCircleSize: CGFloat = 20
        static let dayVerticalSpacing: CGFloat = 6

        // Edge padding
        static let minimumEdgePadding: CGFloat = 8

        // Computed: edge padding to allow first/last items to center
        static func calculateEdgePadding(screenWidth: CGFloat) -> CGFloat {
            // Padding should allow first and last items to scroll to screen center
            // Formula: half screen width minus half item width
            let calculatedPadding = (screenWidth / 2) - (itemWidth / 2)
            return max(calculatedPadding, minimumEdgePadding)
        }
    }

    // MARK: - Initialization

    init(currentCycle: CycleLog?, onDayTapped: @escaping (Date) -> Void) {
        self.currentCycle = currentCycle
        self.onDayTapped = onDayTapped
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            // MARK: - Date Header
            Text(dateHeaderText)
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.title2Tracking)
                .padding(.horizontal, AppTheme.Spacing.xl)

            // MARK: - Separator with Triangle
            separatorWithTriangle

            // MARK: - Scrollable Week View
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.itemSpacing) {
                    ForEach(weekDays, id: \.self) { date in
                        dayPill(for: date)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $centeredDate, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, edgePadding, for: .scrollContent)
        }
        .padding(.top, AppTheme.Spacing.md)
        .onAppear {
            generateWeekDays()
            centeredDate = today.startOfDay
        }
    }

    // MARK: - Day Pill

    private func dayPill(for date: Date) -> some View {
        DayPillView(
            date: date,
            isToday: Calendar.current.isDate(date, inSameDayAs: today),
            isPeriodDay: isPeriodDay(date),
            isCentered: isCenteredDate(date),
            onTap: { onDayTapped(date) }
        )
    }

    // MARK: - Separator View

    private var separatorWithTriangle: some View {
        VStack(spacing: 0) {
            // Horizontal line
            Rectangle()
                .fill(AppTheme.Colors.textSecondary.opacity(0.2))
                .frame(height: Layout.separatorHeight)

            // Centered triangle pointing down
            HStack {
                Spacer()
                Image(systemName: "triangleshape.fill")
                    .font(.system(size: Layout.triangleSize))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .offset(y: Layout.triangleOffset)
                    .rotationEffect(.degrees(180))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Date Header Formatting

    private var dateHeaderText: String {
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

    // MARK: - Generate Days

    private func generateWeekDays() {
        let calendar = Calendar.current

        // Generate 45 days before and after today (91 days total)
        let daysRange = -45...45

        weekDays = daysRange.compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today.startOfDay)
        }
    }

    // MARK: - Helper Methods

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
}

// MARK: - Day Pill Component

private struct DayPillView: View {
    let date: Date
    let isToday: Bool
    let isPeriodDay: Bool
    let isCentered: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: CycleWeekScrollView.Layout.dayVerticalSpacing) {
                // Day letter
                dayLetterView

                // Pill shape
                RoundedRectangle(cornerRadius: CycleWeekScrollView.Layout.cornerRadius)
                    .fill(pillColor)
                    .frame(
                        width: CycleWeekScrollView.Layout.itemWidth,
                        height: currentHeight
                    )
                    .animation(.easeInOut(duration: 0.2), value: isCentered)
            }
            .frame(width: CycleWeekScrollView.Layout.itemWidth)
        }
        .buttonStyle(.plain)
        .id(date)
    }

    private var currentHeight: CGFloat {
        isCentered ? CycleWeekScrollView.Layout.focusedItemHeight : CycleWeekScrollView.Layout.itemHeight
    }

    private var pillColor: Color {
        if isPeriodDay {
            return AppTheme.Colors.error
        } else {
            return AppTheme.Colors.textSecondary.opacity(0.1)
        }
    }

    private var dayLetterView: some View {
        ZStack {
            // Circle background for today
            if isToday {
                Circle()
                    .fill(AppTheme.Colors.textPrimary)
                    .frame(
                        width: CycleWeekScrollView.Layout.todayCircleSize,
                        height: CycleWeekScrollView.Layout.todayCircleSize
                    )
            }

            Text(dayLetter)
                .font(AppTheme.Typography.caption2)
                .foregroundColor(
                    isToday
                        ? AppTheme.Colors.background
                        : AppTheme.Colors.textSecondary
                )
                .fontWeight(isToday ? .bold : .regular)
                .frame(minWidth: CycleWeekScrollView.Layout.dayLetterMinWidth)
        }
    }

    private var dayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"  // Single letter (M, T, W, etc.)
        return formatter.string(from: date).uppercased()
    }
}

// MARK: - Preview

#Preview("No Cycle") {
    CycleWeekScrollView(
        currentCycle: nil,
        onDayTapped: { date in
            print("Tapped: \(date)")
        }
    )
    .background(AppTheme.Colors.background)
}

#Preview("With Cycle") {
    CycleWeekScrollView(
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
            print("Tapped: \(date)")
        }
    )
    .background(AppTheme.Colors.background)
}
