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
                // Single card container combining week view + log section
                VStack(spacing: 0) {
                    // Week View Section
                    CycleWeekView(
                        weekRange: viewModel.weekRange,
                        days: viewModel.weekDays,
                        onPreviousWeek: {
                            viewModel.navigateToPreviousWeek()
                        },
                        onNextWeek: {
                            viewModel.navigateToNextWeek()
                        },
                        onDayTapped: { index in
                            viewModel.selectDay(index)
                        }
                    )

                    // Divider Line
                    Rectangle()
                        .fill(AppTheme.Colors.background)
                        .frame(height: 1)
                        .padding(.horizontal, AppTheme.Spacing.xl)

                    // Log Section
                    CycleLogSection(
                        data: viewModel.logData,
                        onPeriodTapped: {
                            // TODO: Open period modal in next phase
                            print("Period tapped")
                        },
                        onSpottingToggled: { newValue in
                            viewModel.toggleSpotting(newValue)
                        },
                        onSymptomsTapped: {
                            // TODO: Open symptoms modal in next phase
                            print("Symptoms tapped")
                        }
                    )
                }
                .background(Color.white)
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(radius: 4, y: 2)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.md)

                // Future: Cycle Insights card will go here
                // Future: Cycle History card will go here
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
    }
}

#Preview {
    CycleTrackingView(userId: UUID())
}
