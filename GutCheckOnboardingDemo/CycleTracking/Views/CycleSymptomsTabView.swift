import SwiftUI

// MARK: - CycleSymptomsTabView

struct CycleSymptomsTabView: View {
    @Binding var selectedSymptomIds: Set<UUID>
    let repository: SymptomRepositoryProtocol

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(symptomsByCategory, id: \.category) { categoryGroup in
                    Section(categoryGroup.category.rawValue) {
                        ForEach(categoryGroup.symptoms) { symptom in
                            SelectableRow(
                                title: symptom.name,
                                isSelected: selectedSymptomIds.contains(symptom.id),
                                action: { toggleSymptom(symptom.id) }
                            )
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(hex: "FBFAF9"))

            // Selection Counter (sticky at bottom)
            HStack {
                Text("\(selectionCount) symptom\(selectionCount == 1 ? "" : "s") selected")
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

    // MARK: - Computed Properties

    private var symptomsByCategory: [(category: SymptomCategory, symptoms: [Symptom])] {
        // Define exactly which symptoms to show (15 total)
        let allowedSymptomNames: Set<String> = [
            // Digestive & Gut Health (5)
            "Bloating",
            "Constipation",
            "Diarrhea",
            "Gas",
            "Nausea",
            // Cycle & Hormonal (3)
            "Dark/different colored blood",
            "Breast soreness",
            "Cramps",
            // Energy, Mood & Mental Clarity (7)
            "Anxiety",
            "Brain fog",
            "Depression",
            "Mood swings",
            "Fatigue",
            "Irritability",
            "Social withdrawl" // Note: typo in SymptomData.swift
        ]

        // Categories in display order
        let targetCategories: [SymptomCategory] = [
            .digestiveGutHealth,
            .cycleHormonal,
            .energyMoodMental
        ]

        // Get all symptoms from repository, filter to allowed list
        let allSymptoms = repository.allSymptoms
            .filter { allowedSymptomNames.contains($0.name) }

        // Group by category
        return targetCategories.compactMap { category in
            let symptomsInCategory = allSymptoms
                .filter { $0.category == category }
                .sorted { $0.displayOrder < $1.displayOrder }

            guard !symptomsInCategory.isEmpty else { return nil }

            return (category: category, symptoms: symptomsInCategory)
        }
    }

    private var selectionCount: Int {
        selectedSymptomIds.count
    }

    // MARK: - Helper Methods

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
    struct PreviewWrapper: View {
        @State private var selectedSymptomIds: Set<UUID> = []
        let repository = InMemorySymptomRepository.shared

        init() {
            // Get some sample symptom IDs from the allowed list
            let bloating = repository.allSymptoms.first { $0.name == "Bloating" }
            let fatigue = repository.allSymptoms.first { $0.name == "Fatigue" }
            let initialIds = Set([bloating?.id, fatigue?.id].compactMap { $0 })
            _selectedSymptomIds = State(initialValue: initialIds)
        }

        var body: some View {
            CycleSymptomsTabView(
                selectedSymptomIds: $selectedSymptomIds,
                repository: repository
            )
        }
    }

    return PreviewWrapper()
}
