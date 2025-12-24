import SwiftUI

struct CycleWeekScrollView: View {
    let currentCycle: CycleLog?
    let onDayTapped: (Date) -> Void

    // MARK: - State

    @State private var centeredDate: Date?
    @State private var weekDays: [Date] = []
    private let today = Date()

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
            }
        }
        .padding(.top, AppTheme.Spacing.md)
        .onAppear {
            generateWeekDays()
            centeredDate = today.startOfDay
        }
    }

    // MARK: - Day Pill

    private func dayPill(for date: Date) -> some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .fill(AppTheme.Colors.textSecondary.opacity(0.1))
            .frame(
                width: Layout.itemWidth,
                height: Layout.itemHeight
            )
            .id(date)
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
}

// MARK: - Preview

#Preview {
    CycleWeekScrollView(
        currentCycle: nil,
        onDayTapped: { date in
            print("Tapped: \(date)")
        }
    )
    .background(AppTheme.Colors.background)
}
