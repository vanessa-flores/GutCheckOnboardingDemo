import SwiftUI

struct CycleTrackingView: View {
    let userId: UUID
    @State private var viewModel: CycleTrackingViewModel

    init(userId: UUID) {
        self.userId = userId
        self._viewModel = State(initialValue: CycleTrackingViewModel(userId: userId))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {

                    // MARK: - Week View Section
                    // TODO: Add CycleWeekView component here
                    VStack(spacing: AppTheme.Spacing.md) {
                        Text("Week View")
                            .font(AppTheme.Typography.title2)
                            .foregroundColor(AppTheme.Colors.textPrimary)

                        Text("Coming in next step")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.vertical, AppTheme.Spacing.lg)

                    // MARK: - Log Section (Placeholder)
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Log")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.textPrimary)

                        Text("Flow, Cramps, Spotting, Notes coming soon")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppTheme.Spacing.xl)

                    Spacer(minLength: AppTheme.Spacing.xxxl)

                    // MARK: - Cycle History Section (Placeholder)
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        HStack {
                            Text("Recent Cycles")
                                .font(AppTheme.Typography.title3)
                                .foregroundColor(AppTheme.Colors.textPrimary)

                            Spacer()

                            Text("View All")
                                .font(AppTheme.Typography.bodySmall)
                                .foregroundColor(AppTheme.Colors.primaryAction)
                        }

                        Text("Cycle history coming in Phase 2")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
                .padding(.top, AppTheme.Spacing.md)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Cycle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Add manual period entry
                        print("Add period button tapped")
                    }) {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(AppTheme.Colors.primaryAction)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    CycleTrackingView(userId: UUID())
}
