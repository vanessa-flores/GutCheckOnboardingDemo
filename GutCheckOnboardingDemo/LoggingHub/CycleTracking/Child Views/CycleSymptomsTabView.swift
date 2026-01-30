import SwiftUI

// MARK: - CycleSymptomsTabView

struct CycleSymptomsTabView: View {
    let displayData: SymptomsTabDisplayData
    let onSymptomToggled: (UUID) -> Void

    var body: some View {
        VStack(spacing: 0) {
            symptomsList

            selectionCounter
        }
    }

    // MARK: - Private Views

    private var symptomsList: some View {
        List {
            ForEach(displayData.categories) { category in
                Section {
                    ForEach(category.symptoms) { symptom in
                        SelectableRow(
                            title: symptom.name,
                            isSelected: symptom.isSelected
                        ) {
                            onSymptomToggled(symptom.id)
                        }
                    }
                } header: {
                    Text(category.title)
                        .font(AppTheme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.surface)
    }

    private var selectionCounter: some View {
        HStack {
            Text(displayData.selectionCountText)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surfaceSecondary.opacity(0.95))
        .overlay(
            Divider(),
            alignment: .top
        )
    }
}

// MARK: - Preview

#Preview {
    CycleSymptomsTabView(
        displayData: SymptomsTabDisplayData(
            categories: [
                SymptomCategoryDisplayData(
                    id: "digestive",
                    title: "Digestive & Gut Health",
                    symptoms: [
                        SymptomDisplayData(id: UUID(), name: "Bloating", isSelected: true),
                        SymptomDisplayData(id: UUID(), name: "Nausea", isSelected: false)
                    ]
                ),
                SymptomCategoryDisplayData(
                    id: "cycle",
                    title: "Cycle & Hormonal",
                    symptoms: [
                        SymptomDisplayData(id: UUID(), name: "Cramps", isSelected: false),
                        SymptomDisplayData(id: UUID(), name: "Breast soreness", isSelected: true)
                    ]
                )
            ],
            selectionCountText: "2 symptoms selected"
        ),
        onSymptomToggled: { id in print("Toggled: \(id)") }
    )
}
