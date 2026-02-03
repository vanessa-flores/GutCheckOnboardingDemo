import SwiftUI

struct SymptomsTabView: View {
    @Bindable var viewModel: TodaysCheckInViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                Text("What symptoms have you experienced today?")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, AppTheme.Spacing.xl)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.symptomsByCategory, id: \.category) { group in
                        ExpandableSymptomCategorySection(
                            category: group.category,
                            symptoms: group.symptoms,
                            expandedCategories: $viewModel.expandedCategories,
                            selectedSymptomIds: $viewModel.selectedSymptomIds
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .background(AppTheme.Colors.background)
        }
    }
}

// MARK: - Previews

#Preview("Empty State") {
    SymptomsTabView(
        viewModel: TodaysCheckInViewModel(
            userId: UUID(),
            date: Date(),
            repository: InMemorySymptomRepository.shared
        )
    )
}

#Preview("With Selections") {
    let viewModel = TodaysCheckInViewModel(
        userId: UUID(),
        date: Date(),
        repository: InMemorySymptomRepository.shared
    )
    
    if let bloatingSymptom = InMemorySymptomRepository.shared.allSymptoms.first(where: { $0.name == "Bloating" }) {
        viewModel.selectedSymptomIds.insert(bloatingSymptom.id)
    }
    if let gasSymptom = InMemorySymptomRepository.shared.allSymptoms.first(where: { $0.name == "Gas" }) {
        viewModel.selectedSymptomIds.insert(gasSymptom.id)
    }
    
    return SymptomsTabView(viewModel: viewModel)
}
