import SwiftUI

// MARK: - CycleSymptomsTabView

struct CycleSymptomsTabView: View {
    @Bindable var viewModel: CycleLogViewModel

    var body: some View {
        VStack(spacing: 0) {
            symptomsList

            selectionCounter
        }
    }

    // MARK: - Private Views

    private var symptomsList: some View {
        ScrollView {
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
            .padding(.vertical, AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
    }

    private var selectionCounter: some View {
        HStack {
            Text(viewModel.symptomSelectionCountText)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.background)
    }
}

// MARK: - Preview

#Preview {
    CycleSymptomsTabView(
        viewModel: CycleLogViewModel(
            userId: UUID(),
            date: Date(),
            initialFlow: nil,
            initialSelectedSymptomIds: [],
            repository: InMemorySymptomRepository.shared,
            onSave: { _, _, _ in }
        )
    )
}
