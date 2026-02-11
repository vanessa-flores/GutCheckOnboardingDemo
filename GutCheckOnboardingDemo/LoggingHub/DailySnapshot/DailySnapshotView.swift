import SwiftUI

// MARK: - Daily Snapshot View

struct DailySnapshotView: View {
    let displayData: DailySnapshotDisplayData

    @State private var showAllSymptoms = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Label
            Text("DAILY SNAPSHOT")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.top, AppTheme.Spacing.xl)
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

                        Divider()

                        symptomsRow

                        Divider()

                        periodRow
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
        .onChange(of: displayData) { _, _ in
            showAllSymptoms = false
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
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    // MARK: - Symptoms Row

    private var symptomsRow: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
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
                if displayData.symptomNames.isEmpty {
                    notLoggedText
                } else {
                    symptomText
                        .multilineTextAlignment(.trailing)
                }
            }

            // Show More/Less Button
            if displayData.showOverflow {
                Button(action: { showAllSymptoms.toggle() }) {
                    Text(showAllSymptoms ? "Show less" : "Show more")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.primaryAction)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    @ViewBuilder
    private var symptomText: some View {
        if showAllSymptoms, let allText = displayData.allSymptomsText {
            Text(allText)
                .font(AppTheme.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineLimit(nil)
        } else if let preview = displayData.symptomPreview {
            // Parse preview to style the overflow portion
            if displayData.showOverflow {
                let components = preview.components(separatedBy: " …+")
                if components.count == 2 {
                    Text(components[0])
                        .font(AppTheme.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    + Text(" …+\(components[1])")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                } else {
                    Text(preview)
                        .font(AppTheme.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
            } else {
                Text(preview)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
        }
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
        .padding(.vertical, AppTheme.Spacing.sm)
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
                symptomNames: ["bloating", "fatigue"],
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
