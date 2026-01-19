import SwiftUI

struct DayColumnData {
    let dayLabel: String
    let dateNumber: Int
    let flowData: FlowBarData?
    let isToday: Bool
    let isSelected: Bool
    let isFuture: Bool
}

struct CycleDayColumn: View {
    let data: DayColumnData
    let onTap: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Day label (Mon, Tue, etc.)
            Text(data.dayLabel)
                .font(AppTheme.Typography.caption.weight(.medium))
                .foregroundColor(data.isFuture ? AppTheme.Colors.textSecondary.opacity(0.4) : AppTheme.Colors.textSecondary)

            // Spacing between day label and date number
            Spacer()
                .frame(height: AppTheme.Spacing.xxs)

            // Date number with optional today indicator
            ZStack {
                // Today indicator circle
                if data.isToday {
                    Circle()
                        .fill(AppTheme.Colors.primaryAction)
                        .frame(width: 28, height: 28)
                }

                // Date number
                Text("\(data.dateNumber)")
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(
                        data.isToday ? .white :
                        data.isFuture ? AppTheme.Colors.textPrimary.opacity(0.4) :
                        AppTheme.Colors.textPrimary
                    )
            }

            // Spacing between date number and flow bar
            Spacer()
                .frame(height: AppTheme.Spacing.sm)

            // Flow bar
            CycleFlowBar(data: data.flowData)
        }
        .padding(.horizontal, AppTheme.Spacing.xxs)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(
            data.isSelected
                ? AppTheme.Colors.primaryAction.opacity(0.05)
                : Color.clear
        )
        .cornerRadius(AppTheme.CornerRadius.small)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                .stroke(
                    data.isSelected ? AppTheme.Colors.primaryAction : Color.clear,
                    lineWidth: 2
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(duration: AppTheme.Animation.quick), value: isPressed)
        .onTapGesture {
            guard !data.isFuture else { return }
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.quick) {
                isPressed = false
            }
            onTap()
        }
    }
}

#Preview {
    let mockColumns = [
        // Monday: light flow, not today, not selected
        DayColumnData(dayLabel: "Mon", dateNumber: 6, flowData: FlowBarData(flowLevel: .light, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),

        // Tuesday: heavy flow, not today, not selected
        DayColumnData(dayLabel: "Tue", dateNumber: 7, flowData: FlowBarData(flowLevel: .heavy, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),

        // Wednesday: heavy flow, not today, not selected
        DayColumnData(dayLabel: "Wed", dateNumber: 8, flowData: FlowBarData(flowLevel: .heavy, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),

        // Thursday: medium flow, not today, not selected
        DayColumnData(dayLabel: "Thu", dateNumber: 9, flowData: FlowBarData(flowLevel: .medium, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),

        // Friday: medium flow, not today, not selected
        DayColumnData(dayLabel: "Fri", dateNumber: 10, flowData: FlowBarData(flowLevel: .medium, hasSpotting: false), isToday: false, isSelected: false, isFuture: false),

        // Saturday: light flow, not today, IS selected
        DayColumnData(dayLabel: "Sat", dateNumber: 11, flowData: FlowBarData(flowLevel: .light, hasSpotting: false), isToday: false, isSelected: true, isFuture: false),

        // Sunday: no data, IS today, not selected
        DayColumnData(dayLabel: "Sun", dateNumber: 12, flowData: nil, isToday: true, isSelected: false, isFuture: false),
    ]

    return HStack(spacing: 4) {
        ForEach(mockColumns.indices, id: \.self) { index in
            CycleDayColumn(data: mockColumns[index]) {
                print("Tapped day \(mockColumns[index].dateNumber)")
            }
        }
    }
    .padding()
}
