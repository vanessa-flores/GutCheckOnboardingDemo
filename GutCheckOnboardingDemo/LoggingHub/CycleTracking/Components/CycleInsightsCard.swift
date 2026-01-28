import SwiftUI

// MARK: - Cycle Insights Card

/// Presentational component displaying cycle insights and period warning signs
///
/// Shows current cycle status, recent patterns, and symptoms that consistently
/// appear before period onset. Designed to provide pattern recognition without
/// predictions, following GutCheck's perimenopause-first approach.
///
/// - Note: Returns EmptyView when insights is nil (no data to display)
struct CycleInsightsCard: View {
    let insights: CycleInsights?
    let onTap: () -> Void

    @ViewBuilder
    var body: some View {
        if let insights = insights {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    // MARK: - Current Cycle Section

                    // "CURRENT CYCLE" header
                    Text("CURRENT CYCLE")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .textCase(.uppercase)

                    // Day number
                    Text("Day \(insights.currentCycleDay)")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    // Recent cycles info
                    if !insights.recentCycleLengths.isEmpty {
                        let cyclesText = insights.recentCycleLengths.map(String.init).joined(separator: ", ")
                        Text("Recent cycles: \(cyclesText) days")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }

                    // Period length info
                    if !insights.recentPeriodLengths.isEmpty {
                        let periodsText = insights.recentPeriodLengths.map(String.init).joined(separator: ", ")
                        Text("Period lengths: \(periodsText) days")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }

                    // MARK: - Warning Signs Section

                    if insights.hasWarningSignsData,
                       let warningSigns = insights.periodWarningSignsOptional,
                       !warningSigns.isEmpty {

                        Divider()
                            .padding(.vertical, AppTheme.Spacing.xs)

                        // "Your Period Warning Signs" header
                        Text("Your Period Warning Signs")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .padding(.bottom, AppTheme.Spacing.xs)

                        // List of symptoms with bullet points
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            ForEach(warningSigns) { sign in
                                HStack(alignment: .top, spacing: AppTheme.Spacing.xs) {
                                    // Bullet point
                                    Text("•")
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundColor(AppTheme.Colors.primaryAction)

                                    // Symptom name + timing (single line)
                                    Text("\(sign.symptomName) \(sign.daysBeforeRange)")
                                        .font(AppTheme.Typography.bodyMedium)
                                        .foregroundColor(AppTheme.Colors.textPrimary)
                                }
                            }
                        }
                    }

                    // MARK: - More Info Button

                    HStack {
                        Spacer()

                        Text("More Info →")
                            .font(AppTheme.Typography.buttonSecondary)
                            .foregroundColor(AppTheme.Colors.primaryAction)

                        Spacer()
                    }
                    .padding(.top, AppTheme.Spacing.xs)
                }
                .padding(AppTheme.Spacing.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("View detailed cycle insights")
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: AppTheme.Spacing.xl) {
        // Full data state
        CycleInsightsCard(
            insights: CycleInsights(
                currentCycleDay: 47,
                recentCycleLengths: [37, 39, 52],
                recentPeriodLengths: [5, 4, 3],
                periodWarningSignsOptional: [
                    PeriodWarningSign(
                        symptomName: "Bloating",
                        daysBeforeRange: "2-3 days before"
                    ),
                    PeriodWarningSign(
                        symptomName: "Breast tenderness",
                        daysBeforeRange: "3-4 days before"
                    ),
                    PeriodWarningSign(
                        symptomName: "Fatigue",
                        daysBeforeRange: "1-2 days before"
                    )
                ]
            ),
            onTap: {
                print("Insights card tapped")
            }
        )

        // Without warning signs
        CycleInsightsCard(
            insights: CycleInsights(
                currentCycleDay: 12,
                recentCycleLengths: [28, 30, 29],
                recentPeriodLengths: [5, 5, 4],
                periodWarningSignsOptional: nil
            ),
            onTap: {
                print("Insights card tapped")
            }
        )

        // Nil state (should not render)
        CycleInsightsCard(
            insights: nil,
            onTap: {
                print("Insights card tapped")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}
