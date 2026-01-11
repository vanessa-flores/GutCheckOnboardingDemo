import SwiftUI

struct DayColumnData {
    let dayLabel: String
    let dateNumber: Int
    let flowData: FlowBarData?
}

struct CycleDayColumn: View {
    let data: DayColumnData
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Day label (Mon, Tue, etc.)
            Text(data.dayLabel)
                .font(AppTheme.Typography.caption.weight(.medium))
                .foregroundColor(AppTheme.Colors.textSecondary)

            // Spacing between day label and date number
            Spacer()
                .frame(height: AppTheme.Spacing.xxs)

            // Date number
            Text("\(data.dateNumber)")
                .font(AppTheme.Typography.body.weight(.semibold))
                .foregroundColor(AppTheme.Colors.textPrimary)

            // Spacing between date number and flow bar
            Spacer()
                .frame(height: AppTheme.Spacing.sm)

            // Flow bar
            CycleFlowBar(data: data.flowData)
        }
        .padding(.horizontal, AppTheme.Spacing.xxs)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(Color.clear)
        .cornerRadius(AppTheme.CornerRadius.small)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    let mockColumns = [
        DayColumnData(dayLabel: "Mon", dateNumber: 6, flowData: FlowBarData(flowLevel: .heavy, hasSpotting: false)),
        DayColumnData(dayLabel: "Tue", dateNumber: 7, flowData: FlowBarData(flowLevel: .medium, hasSpotting: true)),
        DayColumnData(dayLabel: "Wed", dateNumber: 8, flowData: nil),
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
