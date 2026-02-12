import Foundation

// MARK: - Symptom Filtering Service

/// Utilities for filtering symptoms based on context-specific business rules
///
/// Provides curated symptom lists for different tracking contexts (e.g., cycle tracking)
/// to ensure users see only relevant symptoms in each UI flow.
struct SymptomFilteringService {

    // MARK: - Cycle Tracking Symptoms

    /// Returns symptoms appropriate for cycle tracking context
    ///
    /// Filters the full symptom catalog to 15 specific symptoms across 3 categories:
    /// - Digestive & Gut Health (5 symptoms)
    /// - Cycle & Hormonal (3 symptoms)
    /// - Energy, Mood & Mental Clarity (7 symptoms)
    ///
    /// - Parameter repository: Repository providing access to the full symptom catalog
    /// - Returns: Symptoms grouped by category in display order
    static func cycleTrackingSymptoms(
        from repository: SymptomCatalogProtocol
    ) -> [(category: SymptomCategory, symptoms: [Symptom])] {
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
            "Social withdrawal"
        ]

        // Categories in display order
        let targetCategories: [SymptomCategory] = [
            .cycleHormonal,
            .digestiveGutHealth,
            .energyMoodMental
        ]

        // Get all symptoms from repository, filter to allowed list
        let allSymptoms = repository.allSymptoms
            .filter { allowedSymptomNames.contains($0.name) }

        // Group by category and return domain models
        return targetCategories.compactMap { category in
            let symptomsInCategory = allSymptoms
                .filter { $0.category == category }
                .sorted { $0.name < $1.name }

            guard !symptomsInCategory.isEmpty else { return nil }

            return (category: category, symptoms: symptomsInCategory)
        }
    }

    // MARK: - Daily Check-In Symptoms

    /// Returns symptoms appropriate for daily check-in context
    ///
    /// Filters the full symptom catalog to ~56 symptoms across all categories by excluding
    /// chronic/ongoing symptoms that don't meaningfully fluctuate day to day:
    /// - Excludes 9 symptoms: irregular periods, muscle mass loss, brittle hair/nails,
    ///   unwanted hair growth, skin changes, sensitive skin, UTIs, gum/dental problems,
    ///   weight gain/changes
    /// - Includes all other symptoms from the catalog
    /// - Sorts by category displayOrder, then symptom displayOrder within category
    ///
    /// - Parameter repository: Repository providing access to the full symptom catalog
    /// - Returns: Symptoms grouped by category in display order
    static func dailyCheckInSymptoms(
        from repository: SymptomCatalogProtocol
    ) -> [(category: SymptomCategory, symptoms: [Symptom])] {
        // Define chronic/ongoing symptoms to exclude (9 total)
        let excludedSymptomNames: Set<String> = [
            "Irregular periods",
            "Muscle mass loss",
            "Brittle hair/nails",
            "Unwanted hair growth",
            "Skin changes",
            "Sensitive skin",
            "Urinary Tract Infections (UTIs)",
            "Gum/dental problems",
            "Weight gain/changes"
        ]

        // Get all symptoms, exclude chronic/ongoing symptoms
        let filteredSymptoms = repository.allSymptoms
            .filter { !excludedSymptomNames.contains($0.name) }

        // Group by category and sort by displayOrder
        return filteredSymptoms.groupedByCategory()
    }
}
