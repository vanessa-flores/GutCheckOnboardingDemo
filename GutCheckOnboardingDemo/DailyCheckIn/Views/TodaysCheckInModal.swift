import SwiftUI

// MARK: - TodaysCheckInModal

struct TodaysCheckInModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: TodaysCheckInViewModel
    
    init(userId: UUID, repository: CheckInRepository) {
        let vm = TodaysCheckInViewModel(userId: userId, repository: repository)
        _viewModel = State(initialValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                tabPicker
                
                Divider()
                
                tabContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Today's Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.save()
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var tabPicker: some View {
        Picker("Select Tab", selection: $viewModel.selectedTab) {
            ForEach(CheckInTab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch viewModel.selectedTab {
        case .mood:
            MoodTabView(viewModel: viewModel)
        case .symptoms:
            SymptomsTabView(viewModel: viewModel)
        case .behaviors:
            BehaviorsTabView()
        }
    }
}

// MARK: - Previews

#Preview("Modal - Empty State") {
    TodaysCheckInModal(
        userId: UUID(),
        repository: InMemorySymptomRepository.shared
    )
}

#Preview("Modal - With Data") {
    let repository = InMemorySymptomRepository.shared
    let userId = UUID()
    
    var log = DailyLog.today(for: userId)
    log.mood = .good
    log.reflectionNotes = "Had a productive morning"
    repository.save(dailyLog: log)
    
    return TodaysCheckInModal(
        userId: userId,
        repository: repository
    )
}
