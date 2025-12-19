import Foundation

struct SymptomRepository {
    
    static let allCategories: [OnboardingSymptomCategory] = [
        OnboardingSymptomCategory(
            id: "cycle_hormonal",
            title: "Cycle & Hormonal",
            symptoms: [
                OnboardingSymptom(
                    id: "severe_pms",
                    displayText: "Severe PMS",
                    categoryId: "cycle_hormonal"
                ),
                OnboardingSymptom(
                    id: "cycle_changes",
                    displayText: "Menstrual cycle changes",
                    categoryId: "cycle_hormonal"
                ),
                OnboardingSymptom(
                    id: "night_sweats",
                    displayText: "Night sweats or hot flashes",
                    categoryId: "cycle_hormonal"
                )
            ],
            displayOrder: 1
        ),
        OnboardingSymptomCategory(
            id: "mental_emotional",
            title: "Mental & Emotional",
            symptoms: [
                OnboardingSymptom(
                    id: "anxiety_depression",
                    displayText: "Anxiety or depression",
                    categoryId: "mental_emotional"
                ),
                OnboardingSymptom(
                    id: "mood_changes",
                    displayText: "Mood changes or irritability",
                    categoryId: "mental_emotional"
                ),
                OnboardingSymptom(
                    id: "brain_fog",
                    displayText: "Brain fog or difficulty concentrating",
                    categoryId: "mental_emotional"
                )
            ],
            displayOrder: 2
        ),
        OnboardingSymptomCategory(
            id: "physical_energy",
            title: "Physical & Energy",
            symptoms: [
                OnboardingSymptom(
                    id: "migraines",
                    displayText: "Migraines or headaches",
                    categoryId: "physical_energy"
                ),
                OnboardingSymptom(
                    id: "fatigue",
                    displayText: "Fatigue or low energy",
                    categoryId: "physical_energy"
                ),
                OnboardingSymptom(
                    id: "sleep_issues",
                    displayText: "Sleep issues",
                    categoryId: "physical_energy"
                )
            ],
            displayOrder: 3
        ),
        OnboardingSymptomCategory(
            id: "digestive_metabolic",
            title: "Digestive & Metabolic",
            symptoms: [
                OnboardingSymptom(
                    id: "bloating_ibs",
                    displayText: "Bloating or IBS",
                    categoryId: "digestive_metabolic"
                ),
                OnboardingSymptom(
                    id: "acid_reflux",
                    displayText: "Acid reflux / GERD",
                    categoryId: "digestive_metabolic"
                ),
                OnboardingSymptom(
                    id: "weight_gain",
                    displayText: "Weight gain or body composition changes",
                    categoryId: "digestive_metabolic"
                ),
                OnboardingSymptom(
                    id: "cholesterol_insulin",
                    displayText: "High cholesterol or insulin resistance",
                    categoryId: "digestive_metabolic"
                )
            ],
            displayOrder: 4
        )
    ]
    
    // MARK: - Convenience Accessors
    
    static var allSymptoms: [OnboardingSymptom] {
        allCategories.flatMap { $0.symptoms }
    }
    
    static func symptom(withId id: String) -> OnboardingSymptom? {
        allSymptoms.first { $0.id == id }
    }
    
    static func category(withId id: String) -> OnboardingSymptomCategory? {
        allCategories.first { $0.id == id }
    }
}
