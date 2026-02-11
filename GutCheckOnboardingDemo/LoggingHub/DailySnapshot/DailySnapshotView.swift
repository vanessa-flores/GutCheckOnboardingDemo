import SwiftUI

// MARK: - Daily Snapshot View

struct DailySnapshotView: View {
    let displayData: DailySnapshotDisplayData

    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            HStack {
                Text("Daily Snapshot")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
            }
            .padding(.top, AppTheme.Spacing.lg)
            .padding(.bottom, AppTheme.Spacing.sm)

            // Card Container
            VStack(spacing: 0) {
                if !displayData.hasAnyData {
                    // Empty State
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "clipboard")
                            .font(.system(size: 36))
                            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.35))

                        Text("Nothing logged yet")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                    }
                    .padding(.vertical, AppTheme.Spacing.xl)
                    .padding(.horizontal, AppTheme.Spacing.md)
                } else {
                    // Data State
                    VStack(spacing: 0) {
                        moodRow
                            .padding(.top, AppTheme.Spacing.md)
                        Divider()
                        symptomsRow
                        Divider()
                        periodRow
                            .padding(.bottom, AppTheme.Spacing.md)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }

    // MARK: - Mood Row

    private var moodRow: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            // Icon
            Text(displayData.moodEmoji ?? "😐")
                .font(AppTheme.Typography.body)
                .frame(width: 24)

            // Label
            Text("Mood")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Spacer()

            // Value
            if let moodLabel = displayData.moodLabel {
                Text(moodLabel)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            } else {
                notLoggedText
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }

    // MARK: - Symptoms Row

    private var symptomsRow: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            // Icon
            Image(systemName: "stethoscope")
                .imageScale(.medium)
                .foregroundColor(AppTheme.Colors.primaryAction)
                .frame(width: 24)

            // Label
            Text("Symptoms")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Spacer()

            // Value
            if let symptomsList = displayData.symptomsList {
                Text(symptomsList)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.trailing)
            } else {
                notLoggedText
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    // MARK: - Period Row

    private var periodRow: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            // Icon
            Image(systemName: "drop.fill")
                .imageScale(.medium)
                .foregroundColor(AppTheme.Colors.primaryAction)
                .frame(width: 24)

            // Label
            Text("Period")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Spacer()

            // Value
            if let flowLabel = displayData.flowLabel {
                Text(flowLabel)
                    .textCase(.lowercase)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            } else {
                notLoggedText
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
    }

    // MARK: - Shared Components

    private var notLoggedText: some View {
        Text("Not logged")
            .font(AppTheme.Typography.bodySmall)
            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
            .italic()
    }
}

// MARK: - Preview

#Preview("Empty State") {
    VStack {
        DailySnapshotView(displayData: .empty)
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Partial State") {
    VStack {
        DailySnapshotView(
            displayData: DailySnapshotDisplayData(
                moodEmoji: "🙂",
                moodLabel: "good",
                symptomNames: [],
                flowLabel: nil
            )
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Complete State") {
    VStack {
        DailySnapshotView(
            displayData: DailySnapshotDisplayData(
                moodEmoji: "😐",
                moodLabel: "meh",
                symptomNames: ["brain fog", "fatigue", "mood swings", "bloating", "cramps"],
                flowLabel: "Medium"
            )
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}
