import SwiftUI

struct QuickLogView: View {

    // MARK: - Properties

    @State private var viewModel: QuickLogViewModel

    // MARK: - Initialization

    init(userId: UUID, appRouter: AppRouter) {
        self._viewModel = State(initialValue: QuickLogViewModel(
            userId: userId,
            appRouter: appRouter
        ))
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Subtitle instruction
                subtitleText

                // Categories and pills
                categorySections

                // Footer link
                footerLink
            }
        }
        .background(AppTheme.Colors.background)
    }

    // MARK: - Subtitle

    private var subtitleText: some View {
        Text("Log symptoms as they happen")
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.xl)
    }

    // MARK: - Category Sections

    private var categorySections: some View {
        ForEach(viewModel.orderedCategories, id: \.self) { category in
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                // Category header (all caps, gray)
                Text(category.rawValue.uppercased())
                    .font(AppTheme.Typography.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.horizontal, AppTheme.Spacing.md)

                // Pills using WrappingHStack
                WrappingHStack(
                    horizontalSpacing: AppTheme.Spacing.xs,
                    verticalSpacing: AppTheme.Spacing.sm
                ) {
                    ForEach(viewModel.eventSymptoms[category] ?? [], id: \.id) { symptom in
                        EventSymptomPill(
                            symptom: symptom,
                            onTap: { viewModel.logSymptom(symptom) }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Footer Link

    private var footerLink: some View {
        Button(action: viewModel.navigateToDashboard) {
            HStack(spacing: 4) {
                Text("View today's activity")
                    .font(AppTheme.Typography.bodySmall)

                Image(systemName: "arrow.right")
                    .font(AppTheme.Typography.caption)
            }
            .foregroundColor(AppTheme.Colors.accent)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        QuickLogView(userId: UUID(), appRouter: AppRouter())
            .navigationTitle("Quick Log")
            .navigationBarTitleDisplayMode(.inline)
    }
}
