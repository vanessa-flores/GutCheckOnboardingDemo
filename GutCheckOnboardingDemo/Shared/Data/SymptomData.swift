import Foundation

// MARK: - Symptom Data

/// Master list of all trackable symptoms.
/// These are seeded into the repository on app launch.
/// Organized by category with 10 symptoms per category.
enum SymptomData {
    
    // MARK: - All Symptoms
    
    static let allSymptoms: [Symptom] = {
        var symptoms: [Symptom] = []
        symptoms.append(contentsOf: digestiveSymptoms)
        symptoms.append(contentsOf: hormonalSymptoms)
        symptoms.append(contentsOf: energySymptoms)
        symptoms.append(contentsOf: sleepSymptoms)
        symptoms.append(contentsOf: painSymptoms)
        symptoms.append(contentsOf: skinHarNailsSymptoms)
        symptoms.append(contentsOf: sensorySymptoms)
        symptoms.append(contentsOf: urogenitalSymptoms)
        symptoms.append(contentsOf: otherPhysicalSymptoms)
        return symptoms
    }()
    
    // MARK: - Digestive & Gut Health

    static let digestiveSymptoms: [Symptom] = [
        Symptom(name: "Acid Reflux/GERD", category: .digestiveGutHealth, displayOrder: 0, isEventBased: true),
        Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 1, isEventBased: true),
        Symptom(name: "Constipation", category: .digestiveGutHealth, displayOrder: 2),
        Symptom(name: "Diarrhea", category: .digestiveGutHealth, displayOrder: 3),
        Symptom(name: "Digestive problems/IBS", category: .digestiveGutHealth, displayOrder: 4),
        Symptom(name: "Gas", category: .digestiveGutHealth, displayOrder: 5),
        Symptom(name: "Slow digestion", category: .digestiveGutHealth, displayOrder: 6),
        Symptom(name: "Nausea", category: .digestiveGutHealth, displayOrder: 7, isEventBased: true),
        Symptom(name: "Food intolerances", category: .digestiveGutHealth, displayOrder: 8),
    ]
    
    // MARK: - Cycle & Hormonal
    
    static let hormonalSymptoms: [Symptom] = [
        Symptom(name: "Irregular periods", category: .cycleHormonal, displayOrder: 0),
        Symptom(name: "Heavy bleeding", category: .cycleHormonal, displayOrder: 1),
        Symptom(name: "Spotting", category: .cycleHormonal, displayOrder: 2),
        Symptom(name: "Dark/different colored blood", category: .cycleHormonal, displayOrder: 3),
        Symptom(name: "Extreme PMS symptoms", category: .cycleHormonal, displayOrder: 4),
        Symptom(name: "Breast soreness", category: .cycleHormonal, displayOrder: 5),
    ]
    
    // MARK: - Energy, Mood & Mental Clarity

    static let energySymptoms: [Symptom] = [
        Symptom(name: "Anxiety", category: .energyMoodMental, displayOrder: 0, isEventBased: true),
        Symptom(name: "Brain fog", category: .energyMoodMental, displayOrder: 1),
        Symptom(name: "Depression", category: .energyMoodMental, displayOrder: 2),
        Symptom(name: "Mood swings", category: .energyMoodMental, displayOrder: 3, isEventBased: true),
        Symptom(name: "Fatigue", category: .energyMoodMental, displayOrder: 4),
        Symptom(name: "Irritability", category: .energyMoodMental, displayOrder: 5),
        Symptom(name: "Social withdrawl", category: .energyMoodMental, displayOrder: 6),
    ]
    
    // MARK: - Sleep & Temperature

    static let sleepSymptoms: [Symptom] = [
        Symptom(name: "Hot flashes", category: .sleepTemperature, displayOrder: 0, isEventBased: true),
        Symptom(name: "Night sweats", category: .sleepTemperature, displayOrder: 1, isEventBased: true),
        Symptom(name: "Cold flashes", category: .sleepTemperature, displayOrder: 2),
        Symptom(name: "Difficulty sleeping", category: .sleepTemperature, displayOrder: 3),
    ]
    
    // MARK: - Physical & Pain

    static let painSymptoms: [Symptom] = [
        Symptom(name: "Body aches", category: .physicalPain, displayOrder: 0),
        Symptom(name: "Headaches", category: .physicalPain, displayOrder: 1, isEventBased: true),
        Symptom(name: "Migraines", category: .physicalPain, displayOrder: 2, isEventBased: true),
        Symptom(name: "Joint/muscle pain", category: .physicalPain, displayOrder: 3),
        Symptom(name: "Frozen shoulder", category: .physicalPain, displayOrder: 4),
        Symptom(name: "Muscle mass loss", category: .physicalPain, displayOrder: 5),
        Symptom(name: "Heart racing", category: .physicalPain, displayOrder: 6, isEventBased: true),
        Symptom(name: "Heart palpitations", category: .physicalPain, displayOrder: 7, isEventBased: true),
        Symptom(name: "Dizziness/vertigo", category: .physicalPain, displayOrder: 8, isEventBased: true),
        Symptom(name: "Balance issues", category: .physicalPain, displayOrder: 9),
        Symptom(name: "Feeling clumsy/uncoordinated", category: .physicalPain, displayOrder: 10),
    ]
    
    // MARK: - Skin, Hair & Nails
    
    static let skinHarNailsSymptoms: [Symptom] = [
        Symptom(name: "Acne", category: .skinHairNails, displayOrder: 0),
        Symptom(name: "Brittle hair/nails", category: .skinHairNails, displayOrder: 1),
        Symptom(name: "Hair loss", category: .skinHairNails, displayOrder: 2),
        Symptom(name: "Unwanted hair growth", category: .skinHairNails, displayOrder: 3),
        Symptom(name: "Skin changes", category: .skinHairNails, displayOrder: 4),
        Symptom(name: "Skin crawling", category: .skinHairNails, displayOrder: 5),
        Symptom(name: "Dry skin", category: .skinHairNails, displayOrder: 6),
        Symptom(name: "Itchiness (overall skin)", category: .skinHairNails, displayOrder: 7),
        Symptom(name: "Sensitive skin", category: .skinHairNails, displayOrder: 8),
    ]
    
    // MARK: - Sensory
    
    static let sensorySymptoms: [Symptom] = [
        Symptom(name: "Sensitive teeth", category: .sensory, displayOrder: 0),
        Symptom(name: "Sensitivity to sound", category: .sensory, displayOrder: 1),
        Symptom(name: "Sense of smell changes", category: .sensory, displayOrder: 2),
        Symptom(name: "Tingling extremities", category: .sensory, displayOrder: 3),
        Symptom(name: "Tinnitus", category: .sensory, displayOrder: 4),
        Symptom(name: "Itchy ears", category: .sensory, displayOrder: 5),
        Symptom(name: "Burning mouth", category: .sensory, displayOrder: 6),
        Symptom(name: "Dry mouth", category: .sensory, displayOrder: 7),
        Symptom(name: "Dry eyes", category: .sensory, displayOrder: 8),
    ]
    
    // MARK: - Urogenital
    
    static let urogenitalSymptoms: [Symptom] = [
        Symptom(name: "Low/decreased libido", category: .urogenital, displayOrder: 0),
        Symptom(name: "Stress incontinence", category: .urogenital, displayOrder: 1),
        Symptom(name: "Urinary Tract Infections (UTIs)", category: .urogenital, displayOrder: 2),
    ]
    
    // MARK: - Other Physical

    static let otherPhysicalSymptoms: [Symptom] = [
        Symptom(name: "Allergies (new, different)", category: .otherPhysical, displayOrder: 0),
        Symptom(name: "Body odor changes", category: .otherPhysical, displayOrder: 1),
        Symptom(name: "Gum/dental problems", category: .otherPhysical, displayOrder: 2),
        Symptom(name: "Restless Leg Syndrome", category: .otherPhysical, displayOrder: 3),
        Symptom(name: "Swelling of hands/feet", category: .otherPhysical, displayOrder: 4),
        Symptom(name: "Weight gain/changes", category: .otherPhysical, displayOrder: 5),
    ]
}

// MARK: - Symptom Lookup Helpers

extension SymptomData {
    /// Find a symptom by name (case-insensitive)
    static func symptom(named name: String) -> Symptom? {
        allSymptoms.first { $0.name.lowercased() == name.lowercased() }
    }

    /// Get all symptom names for a category
    static func symptomNames(for category: SymptomCategory) -> [String] {
        allSymptoms
            .filter { $0.category == category }
            .sorted { $0.displayOrder < $1.displayOrder }
            .map { $0.name }
    }
}
