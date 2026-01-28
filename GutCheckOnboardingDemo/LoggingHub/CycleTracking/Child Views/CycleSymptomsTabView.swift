import SwiftUI

// MARK: - CycleSymptomsTabView

struct CycleSymptomsTabView: View {
    let displayData: SymptomsTabDisplayData
    let onSymptomToggled: (UUID) -> Void

    var body: some View {
        VStack(spacing: 0) {
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
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(hex: "FBFAF9"))

            // Selection Counter (sticky at bottom)
            HStack {
                Text(displayData.selectionCountText)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                Color(hex: "F8F6F3")
                    .opacity(0.95)
            )
            .overlay(
                Divider()
                    .padding(.horizontal, 0),
                alignment: .top
            )
        }
    }
}

// MARK: - Preview

#Preview {
    CycleSymptomsTabView(
        displayData: SymptomsTabDisplayData(
            categories: [
                SymptomCategoryDisplayData(
                    id: "digestive",
                    title: "DIGESTIVE & GUT HEALTH",
                    symptoms: [
                        SymptomDisplayData(id: UUID(), name: "Bloating", isSelected: true),
                        SymptomDisplayData(id: UUID(), name: "Nausea", isSelected: false)
                    ]
                ),
                SymptomCategoryDisplayData(
                    id: "cycle",
                    title: "CYCLE & HORMONAL",
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
