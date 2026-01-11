import SwiftUI

struct DayData {
    let dayLabel: String
    let dateNumber: Int
}

struct CycleWeekDayLabels: View {
    let days: [DayData]

    var body: some View {
        HStack {
            ForEach(days.indices, id: \.self) { index in
                VStack(spacing: AppTheme.Spacing.xxs) {
                    // Day label (Mon, Tue, etc.)
                    Text(days[index].dayLabel)
                        .font(AppTheme.Typography.caption.weight(.medium))
                        .foregroundColor(AppTheme.Colors.textSecondary)

                    // Date number
                    Text("\(days[index].dateNumber)")
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }

                if index < days.count - 1 {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let mockDays = [
        DayData(dayLabel: "Mon", dateNumber: 6),
        DayData(dayLabel: "Tue", dateNumber: 7),
        DayData(dayLabel: "Wed", dateNumber: 8),
        DayData(dayLabel: "Thu", dateNumber: 9),
        DayData(dayLabel: "Fri", dateNumber: 10),
        DayData(dayLabel: "Sat", dateNumber: 11),
        DayData(dayLabel: "Sun", dateNumber: 12)
    ]

    return CycleWeekDayLabels(days: mockDays)
        .padding()
}
