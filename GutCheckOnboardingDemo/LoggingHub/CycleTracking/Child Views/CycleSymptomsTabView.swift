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
                    categorySection(group.category, symptoms: group.symptoms)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.surface)
    }

    private func categorySection(_ category: SymptomCategory, symptoms: [Symptom]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: AppTheme.Animation.quick)) {
                    viewModel.toggleCategory(category)
                }
            } label: {
                HStack {
                    Text(category.rawValue)
                        .font(AppTheme.Typography.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

                    Image(systemName: viewModel.isCategoryExpanded(category) ? "chevron.down" : "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.vertical, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.sm)
            }
            .buttonStyle(PlainHeaderButtonStyle())

            if viewModel.isCategoryExpanded(category) {
                symptomTags(symptoms)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.top, AppTheme.Spacing.xs)
                    .padding(.bottom, AppTheme.Spacing.sm)
            }
        }
        .background(AppTheme.Colors.surfaceSecondary)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }

    private func symptomTags(_ symptoms: [Symptom]) -> some View {
        FlowLayout(spacing: AppTheme.Spacing.xs) {
            ForEach(symptoms) { symptom in
                SymptomTag(
                    text: symptom.name,
                    isSelected: viewModel.isSymptomSelected(symptom.id),
                    onTap: {
                        viewModel.toggleSymptom(symptom.id)
                    }
                )
            }
        }
    }

    private var selectionCounter: some View {
        HStack {
            Text(viewModel.symptomSelectionCountText)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surface)
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
