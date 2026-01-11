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
                        weekRange: "Jan 6 - Jan 12",
                        days: mockDays,
                        onPreviousWeek: {
                            print("Previous week tapped")
                        },
                        onNextWeek: {
                            print("Next week tapped")
                        },
                        onDayTapped: { index in
                            print("Day \(index) tapped")
                        }
                    )

                    Divider()
                        .padding(.horizontal, AppTheme.Spacing.xl)

                    // Log Section
                    CycleLogSection(
                        data: mockLogData,
                        onPeriodTapped: {
                            print("Period tapped")
                        },
                        onSpottingToggled: { newValue in
                            print("Spotting toggled to: \(newValue)")
                        },
                        onSymptomsTapped: {
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
        .onAppear {
            viewModel.loadData()
        }
    }

    // MARK: - Mock Data

    private var mockDays: [DayColumnData] {
        [
            DayColumnData(dayLabel: "M", dateNumber: 6, flowData: FlowBarData(flowLevel: .heavy, hasSpotting: false), isToday: false, isSelected: false),
            DayColumnData(dayLabel: "T", dateNumber: 7, flowData: FlowBarData(flowLevel: .medium, hasSpotting: true), isToday: false, isSelected: false),
            DayColumnData(dayLabel: "W", dateNumber: 8, flowData: nil, isToday: true, isSelected: true),
            DayColumnData(dayLabel: "Th", dateNumber: 9, flowData: nil, isToday: false, isSelected: false),
            DayColumnData(dayLabel: "F", dateNumber: 10, flowData: nil, isToday: false, isSelected: false),
            DayColumnData(dayLabel: "Sa", dateNumber: 11, flowData: nil, isToday: false, isSelected: false),
            DayColumnData(dayLabel: "Su", dateNumber: 12, flowData: nil, isToday: false, isSelected: false),
        ]
    }

    private var mockLogData: LogData {
        LogData(
            selectedDate: "Wed, Jan 8",
            periodValue: nil,
            hasSpotting: false,
            symptomsPreview: nil
        )
    }
}

#Preview {
    CycleTrackingView(userId: UUID())
}
