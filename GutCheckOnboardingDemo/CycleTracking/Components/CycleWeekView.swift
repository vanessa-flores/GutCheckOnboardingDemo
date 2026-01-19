import SwiftUI

struct CycleWeekView: View {
    let weekRange: String
    let days: [DayColumnData]
    let onPreviousWeek: () -> Void
    let onNextWeek: () -> Void
    let onDayTapped: (Int) -> Void // Pass day index when tapped

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            // Week header
            CycleWeekHeader(
                weekRange: weekRange,
                onPreviousWeek: onPreviousWeek,
                onNextWeek: onNextWeek
            )

            // Day columns
            HStack(spacing: AppTheme.Spacing.xs) {
                ForEach(days.indices, id: \.self) { index in
                    CycleDayColumn(data: days[index]) {
                        onDayTapped(index)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.xl)
        .background(Color.white)
    }
}

#Preview {
    let mockDays: [DayColumnData] = [
        DayColumnData(dayLabel: "Mon", dateNumber: 6, flowData: FlowBarData(flowLevel: .heavy, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),
        DayColumnData(dayLabel: "Tue", dateNumber: 7, flowData: FlowBarData(flowLevel: .medium, hasSpotting: true), isToday: false, isSelected: false, isFuture: false),
        DayColumnData(dayLabel: "Wed", dateNumber: 8, flowData: nil, isToday: true, isSelected: true, isFuture: false),
        DayColumnData(dayLabel: "Thu", dateNumber: 9, flowData: nil, isToday: false, isSelected: false, isFuture: true),
        DayColumnData(dayLabel: "Fri", dateNumber: 10, flowData: nil, isToday: false, isSelected: false, isFuture: true),
        DayColumnData(dayLabel: "Sat", dateNumber: 11, flowData: nil, isToday: false, isSelected: false, isFuture: true),
        DayColumnData(dayLabel: "Sun", dateNumber: 12, flowData: nil, isToday: false, isSelected: false, isFuture: true),
    ]

    CycleWeekView(
        weekRange: "Jan 6 - Jan 12",
        days: mockDays,
        onPreviousWeek: {
            print("Previous week tapped")
        },
        onNextWeek: {
            print("Next week tapped")
        },
        onDayTapped: { index in
            print("Day \(index) tapped")
        }
    )
    .padding()
    .background(AppTheme.Colors.background)
}
