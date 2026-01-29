import SwiftUI

struct CycleWeekHeader: View {
    let weekRange: String
    let onPreviousWeek: () -> Void
    let onNextWeek: () -> Void

    var body: some View {
        HStack {
            // Week label
            Text(weekRange)
                .font(AppTheme.Typography.body.weight(.medium))
                .foregroundColor(AppTheme.Colors.textPrimary)

            Spacer()

            // Navigation buttons
            HStack(spacing: AppTheme.Spacing.xs) {
                // Previous week button
                Button(action: onPreviousWeek) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(AppTheme.Colors.background)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }

                // Next week button
                Button(action: onNextWeek) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(AppTheme.Colors.background)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
            }
        }
    }
}

#Preview {
    CycleWeekHeader(
        weekRange: "Jan 6 - Jan 12",
        onPreviousWeek: {},
        onNextWeek: {}
    )
    .padding()
    .background(AppTheme.Colors.surface)
    .cornerRadius(AppTheme.CornerRadius.large)
}
