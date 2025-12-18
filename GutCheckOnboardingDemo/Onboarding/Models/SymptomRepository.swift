import Foundation

struct SymptomRepository {
    
    static let allCategories: [SymptomCategory] = [
        SymptomCategory(
            id: "cycle_hormonal",
            title: "Cycle & Hormonal",
            symptoms: [
                Symptom(
                    id: "severe_pms",
                    displayText: "Severe PMS",
                    categoryId: "cycle_hormonal"
                ),
                Symptom(
                    id: "cycle_changes",
                    displayText: "Menstrual cycle changes",
                    categoryId: "cycle_hormonal"
                ),
                Symptom(
                    id: "night_sweats",
                    displayText: "Night sweats or hot flashes",
                    categoryId: "cycle_hormonal"
                )
            ],
            displayOrder: 1
        ),
        SymptomCategory(
            id: "mental_emotional",
            title: "Mental & Emotional",
            symptoms: [
                Symptom(
                    id: "anxiety_depression",
                    displayText: "Anxiety or depression",
                    categoryId: "mental_emotional"
                ),
                Symptom(
                    id: "mood_changes",
                    displayText: "Mood changes or irritability",
                    categoryId: "mental_emotional"
                ),
                Symptom(
                    id: "brain_fog",
                    displayText: "Brain fog or difficulty concentrating",
                    categoryId: "mental_emotional"
                )
            ],
            displayOrder: 2
        ),
        SymptomCategory(
            id: "physical_energy",
            title: "Physical & Energy",
            symptoms: [
                Symptom(
                    id: "migraines",
                    displayText: "Migraines or headaches",
                    categoryId: "physical_energy"
                ),
                Symptom(
                    id: "fatigue",
                    displayText: "Fatigue or low energy",
                    categoryId: "physical_energy"
                ),
                Symptom(
                    id: "sleep_issues",
                    displayText: "Sleep issues",
                    categoryId: "physical_energy"
                )
            ],
            displayOrder: 3
        ),
        SymptomCategory(
            id: "digestive_metabolic",
            title: "Digestive & Metabolic",
            symptoms: [
                Symptom(
                    id: "bloating_ibs",
                    displayText: "Bloating or IBS",
                    categoryId: "digestive_metabolic"
                ),
                Symptom(
                    id: "acid_reflux",
                    displayText: "Acid reflux / GERD",
                    categoryId: "digestive_metabolic"
                ),
                Symptom(
                    id: "weight_gain",
                    displayText: "Weight gain or body composition changes",
                    categoryId: "digestive_metabolic"
                ),
                Symptom(
                    id: "cholesterol_insulin",
                    displayText: "High cholesterol or insulin resistance",
                    categoryId: "digestive_metabolic"
                )
            ],
            displayOrder: 4
        )
    ]
    
    // MARK: - Convenience Accessors
    
    static var allSymptoms: [Symptom] {
        allCategories.flatMap { $0.symptoms }
    }
    
    static func symptom(withId id: String) -> Symptom? {
        allSymptoms.first { $0.id == id }
    }
    
    static func category(withId id: String) -> SymptomCategory? {
        allCategories.first { $0.id == id }
    }
}
