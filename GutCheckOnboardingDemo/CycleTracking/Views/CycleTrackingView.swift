import SwiftUI

struct CycleTrackingView: View {
    let userId: UUID
    @State private var viewModel: CycleTrackingViewModel
    @State private var showingPeriodModal = false
    @State private var showingSymptomsModal = false

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

                    Divider()
                        .padding(.horizontal, AppTheme.Spacing.xl)

                    // Log Section
                    CycleLogSection(
                        data: viewModel.logData,
                        onPeriodTapped: {
                            showingPeriodModal = true
                        },
                        onSpottingToggled: { newValue in
                            viewModel.toggleSpotting(newValue)
                        },
                        onSymptomsTapped: {
                            showingSymptomsModal = true
                        }
                    )
                }
                .background(Color.white)
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(radius: 4, y: 2)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.md)

                // Cycle Insights Card
                CycleInsightsCard(
                    insights: viewModel.cycleInsights,
                    onTap: {
                        print("Insights tapped")
                    }
                )
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.bottom, AppTheme.Spacing.md)

                // Future: Cycle History card will go here
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Cycle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // DEMO NOTE: Manual period entry will be implemented in future iteration
                        print("Add period button tapped")
                    }) {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(AppTheme.Colors.primaryAction)
                    }
                }
            }
            .sheet(isPresented: $showingPeriodModal) {
                PeriodLogModal(
                    date: viewModel.logData.selectedDate,
                    initialFlow: {
                        guard let periodValue = viewModel.logData.periodValue else { return nil }
                        return FlowLevel(rawValue: periodValue)
                    }(),
                    initialTracking: viewModel.logData.periodValue != nil,
                    onSave: { isTracking, flowLevel in
                        viewModel.updatePeriodData(isTracking: isTracking, flowLevel: flowLevel)
                    }
                )
            }
            .sheet(isPresented: $showingSymptomsModal) {
                SymptomsLogModal(
                    date: viewModel.logData.selectedDate,
                    initialSelectedIds: viewModel.logData.selectedSymptomIds,
                    repository: InMemorySymptomRepository.shared,
                    onSave: { selectedIds in
                        viewModel.updateSymptomsData(selectedIds: selectedIds)
                    }
                )
            }
        }
    }
}

#Preview {
    CycleTrackingView(userId: SampleCycleData.sampleUserId)
}
