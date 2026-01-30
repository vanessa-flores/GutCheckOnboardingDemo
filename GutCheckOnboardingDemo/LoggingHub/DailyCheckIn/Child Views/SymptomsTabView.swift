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
                        categorySection(group.category, symptoms: group.symptoms)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .background(AppTheme.Colors.surface)
    }
    
    private func categorySection(_ category: SymptomCategory, symptoms: [Symptom]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
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
                symptomTag(symptom)
            }
        }
    }
    
    private func symptomTag(_ symptom: Symptom) -> some View {
        let isSelected = viewModel.isSymptomSelected(symptom.id)
        
        return Text(symptom.name)
            .font(AppTheme.Typography.caption)
            .foregroundStyle(isSelected ? AppTheme.Colors.textOnPrimary : AppTheme.Colors.textPrimary)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.surface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
            .onTapGesture {
                viewModel.toggleSymptom(symptom.id)
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
