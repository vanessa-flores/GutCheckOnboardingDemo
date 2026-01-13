import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct SymptomsLogModal: View {
    @Environment(\.dismiss) private var dismiss

    let date: String // "Wednesday, Jan 8"
    let initialSelectedIds: Set<UUID> // Currently logged symptom IDs
    let onSave: (Set<UUID>) -> Void // Selected symptom IDs

    @State private var selectedSymptomIds: Set<UUID>

    // Repository to fetch symptom details
    private let repository: SymptomRepositoryProtocol

    init(
        date: String,
        initialSelectedIds: Set<UUID>,
        repository: SymptomRepositoryProtocol,
        onSave: @escaping (Set<UUID>) -> Void
    ) {
        self.date = date
        self.initialSelectedIds = initialSelectedIds
        self.repository = repository
        self.onSave = onSave

        // Initialize with current selection
        self._selectedSymptomIds = State(initialValue: initialSelectedIds)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                contentBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Date subtitle
                            Text(date)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, AppTheme.Spacing.sm)
                                .padding(.bottom, AppTheme.Spacing.md)

                            // Loop through categories
                            ForEach(symptomsByCategory, id: \.category) { categoryGroup in
                                // Category Header
                                Text(categoryGroup.category.rawValue.uppercased())
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, AppTheme.Spacing.md)
                                    .padding(.top, AppTheme.Spacing.sm)
                                    .padding(.bottom, AppTheme.Spacing.xs)

                                // Symptoms List for this category
                                VStack(spacing: 0) {
                                    ForEach(categoryGroup.symptoms) { symptom in
                                        Button(action: {
                                            toggleSymptom(symptom.id)
                                        }) {
                                            HStack {
                                                Text(symptom.name)
                                                    .font(AppTheme.Typography.body)
                                                    .foregroundColor(AppTheme.Colors.textPrimary)

                                                Spacer()

                                                if selectedSymptomIds.contains(symptom.id) {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 20, weight: .bold))
                                                        .foregroundColor(AppTheme.Colors.primaryAction)
                                                }
                                            }
                                            .padding(AppTheme.Spacing.md)
                                            .background(Color.white)
                                        }
                                        .buttonStyle(PlainButtonStyle())

                                        if symptom.id != categoryGroup.symptoms.last?.id {
                                            Divider()
                                                .padding(.leading, AppTheme.Spacing.md)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(AppTheme.CornerRadius.medium)
                                .padding(.horizontal, AppTheme.Spacing.md)
                                .padding(.bottom, AppTheme.Spacing.sm)
                            }
                        }
                    }

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
            .navigationTitle("Symptoms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave(selectedSymptomIds)
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
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

#Preview {
    let repository = InMemorySymptomRepository.shared

    // Get some sample symptom IDs from the allowed list
    let bloating = repository.allSymptoms.first { $0.name == "Bloating" }
    let fatigue = repository.allSymptoms.first { $0.name == "Fatigue" }

    let initialIds = Set([bloating?.id, fatigue?.id].compactMap { $0 })

    SymptomsLogModal(
        date: "Wednesday, Jan 8",
        initialSelectedIds: initialIds,
        repository: repository,
        onSave: { selectedIds in
            print("Selected \(selectedIds.count) symptoms")
        }
    )
}
