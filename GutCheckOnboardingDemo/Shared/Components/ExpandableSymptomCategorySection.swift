import SwiftUI

// MARK: - ExpandableSymptomCategorySection

struct ExpandableSymptomCategorySection: View {

    // MARK: - Properties

    let category: SymptomCategory
    let symptoms: [Symptom]
    @Binding var expandedCategories: Set<SymptomCategory>
    @Binding var selectedSymptomIds: Set<UUID>

    // MARK: - Computed Properties

    var isExpanded: Bool {
        expandedCategories.contains(category)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: toggleCategory) {
                HStack {
                    Text(category.rawValue)
                        .font(AppTheme.Typography.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.vertical, AppTheme.Spacing.md)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            .buttonStyle(PlainHeaderButtonStyle())

            if isExpanded {
                FlowLayout(spacing: AppTheme.Spacing.xs) {
                    ForEach(symptoms) { symptom in
                        SymptomTag(
                            text: symptom.name,
                            isSelected: selectedSymptomIds.contains(symptom.id),
                            onTap: {
                                toggleSymptom(symptom.id)
                            }
                        )
                    }
                }
                .padding(.top, AppTheme.Spacing.xxs)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
            }
        }
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.large)
    }

    // MARK: - Actions

    private func toggleCategory() {
        withAnimation(.easeInOut(duration: AppTheme.Animation.quick)) {
            if expandedCategories.contains(category) {
                expandedCategories.remove(category)
            } else {
                expandedCategories.insert(category)
            }
        }
    }

    private func toggleSymptom(_ symptomId: UUID) {
        if selectedSymptomIds.contains(symptomId) {
            selectedSymptomIds.remove(symptomId)
        } else {
            selectedSymptomIds.insert(symptomId)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: AppTheme.Spacing.md) {
        // Expanded state with some selections
        ExpandableSymptomCategorySection(
            category: .digestiveGutHealth,
            symptoms: [
                Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 1),
                Symptom(name: "Constipation", category: .digestiveGutHealth, displayOrder: 2),
                Symptom(name: "Diarrhea", category: .digestiveGutHealth, displayOrder: 3),
                Symptom(name: "Gas", category: .digestiveGutHealth, displayOrder: 4),
                Symptom(name: "Nausea", category: .digestiveGutHealth, displayOrder: 5)
            ],
            expandedCategories: .constant([.digestiveGutHealth]),
            selectedSymptomIds: .constant([
                Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 1).id,
                Symptom(name: "Gas", category: .digestiveGutHealth, displayOrder: 4).id
            ])
        )

        // Collapsed state
        ExpandableSymptomCategorySection(
            category: .energyMoodMental,
            symptoms: [
                Symptom(name: "Anxiety", category: .energyMoodMental, displayOrder: 1),
                Symptom(name: "Brain fog", category: .energyMoodMental, displayOrder: 2),
                Symptom(name: "Fatigue", category: .energyMoodMental, displayOrder: 3)
            ],
            expandedCategories: .constant([]),
            selectedSymptomIds: .constant([])
        )
    }
    .padding(AppTheme.Spacing.xl)
    .background(AppTheme.Colors.background)
}
