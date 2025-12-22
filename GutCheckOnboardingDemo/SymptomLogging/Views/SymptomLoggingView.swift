import SwiftUI

// MARK: - Symptom Logging View

/// Main container view for the symptom logging interface.
/// Displays a list of user's tracked symptoms with logging controls.
struct SymptomLoggingView: View {

    // MARK: - Properties

    @State private var viewModel = SymptomLoggingViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            if viewModel.isLoading {
                loadingView
            } else if !viewModel.hasTrackedSymptoms {
                emptyStateView
            } else {
                contentView
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }

    // MARK: - Content View

    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header with date
                headerSection

                // Section title
                sectionTitle

                // Symptom list
                symptomList

                // Footer with summary
                footerSection
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.md)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        Text(viewModel.todayDateString)
            .font(AppTheme.Typography.title3)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .padding(.bottom, AppTheme.Spacing.xl)
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("Your Symptoms")
            .font(AppTheme.Typography.bodyMedium)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .padding(.bottom, AppTheme.Spacing.md)
    }

    // MARK: - Symptom List

    private var symptomList: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            ForEach(viewModel.trackedSymptoms) { symptom in
                SymptomRow(
                    symptom: symptom,
                    currentLog: viewModel.getLog(for: symptom),
                    isExpanded: viewModel.isExpanded(symptom),
                    onTap: {
                        handleSymptomTap(symptom)
                    },
                    onSelectSeverity: { severity in
                        viewModel.updateSeverity(symptom, severity: severity)
                    },
                    onRemove: {
                        viewModel.removeLog(symptom)
                    }
                )
            }
        }
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(viewModel.summaryText)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)

            if let lastUpdatedText = viewModel.lastUpdatedText {
                Text(lastUpdatedText)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.7))
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ProgressView()
                .tint(AppTheme.Colors.primaryAction)

            Text("Loading symptoms...")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    // MARK: - Empty State View

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()

            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.4))

            VStack(spacing: AppTheme.Spacing.sm) {
                Text("No symptoms selected yet")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text("Choose symptoms in Getting Started to start tracking your patterns")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }

            Spacer()
        }
    }

    // MARK: - Actions

    private func handleSymptomTap(_ symptom: Symptom) {
        if viewModel.isLogged(symptom) {
            // Toggle expanded state for already logged symptoms
            viewModel.toggleExpanded(symptom.id)
        } else {
            // Log new symptom
            viewModel.logSymptom(symptom)
        }
    }
}

// MARK: - Preview

#Preview("With Symptoms") {
    SymptomLoggingView()
}

#Preview("Empty State") {
    SymptomLoggingView()
}
