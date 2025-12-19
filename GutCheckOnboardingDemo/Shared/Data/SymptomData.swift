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
        symptoms.append(contentsOf: painSymptoms)
        symptoms.append(contentsOf: mentalSymptoms)
        symptoms.append(contentsOf: skinSymptoms)
        return symptoms
    }()

    // MARK: - Digestive Symptoms (10)

    static let digestiveSymptoms: [Symptom] = [
        Symptom(name: "Bloating", category: .digestive, displayOrder: 1),
        Symptom(name: "Gas", category: .digestive, displayOrder: 2),
        Symptom(name: "Constipation", category: .digestive, displayOrder: 3),
        Symptom(name: "Diarrhea", category: .digestive, displayOrder: 4),
        Symptom(name: "Nausea", category: .digestive, displayOrder: 5),
        Symptom(name: "Acid Reflux", category: .digestive, displayOrder: 6),
        Symptom(name: "Stomach Cramps", category: .digestive, displayOrder: 7),
        Symptom(name: "Loss of Appetite", category: .digestive, displayOrder: 8),
        Symptom(name: "Food Sensitivities", category: .digestive, displayOrder: 9),
        Symptom(name: "Indigestion", category: .digestive, displayOrder: 10)
    ]

    // MARK: - Hormonal Symptoms (10)

    static let hormonalSymptoms: [Symptom] = [
        Symptom(name: "Hot Flashes", category: .hormonal, displayOrder: 1),
        Symptom(name: "Night Sweats", category: .hormonal, displayOrder: 2),
        Symptom(name: "Irregular Periods", category: .hormonal, displayOrder: 3),
        Symptom(name: "Heavy Bleeding", category: .hormonal, displayOrder: 4),
        Symptom(name: "Spotting", category: .hormonal, displayOrder: 5),
        Symptom(name: "Breast Tenderness", category: .hormonal, displayOrder: 6),
        Symptom(name: "Water Retention", category: .hormonal, displayOrder: 7),
        Symptom(name: "Weight Changes", category: .hormonal, displayOrder: 8),
        Symptom(name: "Low Libido", category: .hormonal, displayOrder: 9),
        Symptom(name: "Vaginal Dryness", category: .hormonal, displayOrder: 10)
    ]

    // MARK: - Energy & Sleep Symptoms (10)

    static let energySymptoms: [Symptom] = [
        Symptom(name: "Fatigue", category: .energySleep, displayOrder: 1),
        Symptom(name: "Insomnia", category: .energySleep, displayOrder: 2),
        Symptom(name: "Difficulty Falling Asleep", category: .energySleep, displayOrder: 3),
        Symptom(name: "Waking During Night", category: .energySleep, displayOrder: 4),
        Symptom(name: "Morning Grogginess", category: .energySleep, displayOrder: 5),
        Symptom(name: "Afternoon Energy Crash", category: .energySleep, displayOrder: 6),
        Symptom(name: "Restless Sleep", category: .energySleep, displayOrder: 7),
        Symptom(name: "Vivid Dreams", category: .energySleep, displayOrder: 8),
        Symptom(name: "Sleep Apnea Symptoms", category: .energySleep, displayOrder: 9),
        Symptom(name: "Exhaustion After Rest", category: .energySleep, displayOrder: 10)
    ]

    // MARK: - Pain & Discomfort Symptoms (10)

    static let painSymptoms: [Symptom] = [
        Symptom(name: "Headaches", category: .painDiscomfort, displayOrder: 1),
        Symptom(name: "Migraines", category: .painDiscomfort, displayOrder: 2),
        Symptom(name: "Joint Pain", category: .painDiscomfort, displayOrder: 3),
        Symptom(name: "Muscle Aches", category: .painDiscomfort, displayOrder: 4),
        Symptom(name: "Back Pain", category: .painDiscomfort, displayOrder: 5),
        Symptom(name: "Neck Tension", category: .painDiscomfort, displayOrder: 6),
        Symptom(name: "Pelvic Pain", category: .painDiscomfort, displayOrder: 7),
        Symptom(name: "Menstrual Cramps", category: .painDiscomfort, displayOrder: 8),
        Symptom(name: "Jaw Tension/TMJ", category: .painDiscomfort, displayOrder: 9),
        Symptom(name: "General Body Aches", category: .painDiscomfort, displayOrder: 10)
    ]

    // MARK: - Mental & Emotional Symptoms (10)

    static let mentalSymptoms: [Symptom] = [
        Symptom(name: "Anxiety", category: .mentalEmotional, displayOrder: 1),
        Symptom(name: "Mood Swings", category: .mentalEmotional, displayOrder: 2),
        Symptom(name: "Irritability", category: .mentalEmotional, displayOrder: 3),
        Symptom(name: "Depression", category: .mentalEmotional, displayOrder: 4),
        Symptom(name: "Brain Fog", category: .mentalEmotional, displayOrder: 5),
        Symptom(name: "Difficulty Concentrating", category: .mentalEmotional, displayOrder: 6),
        Symptom(name: "Memory Issues", category: .mentalEmotional, displayOrder: 7),
        Symptom(name: "Feeling Overwhelmed", category: .mentalEmotional, displayOrder: 8),
        Symptom(name: "Low Motivation", category: .mentalEmotional, displayOrder: 9),
        Symptom(name: "Emotional Sensitivity", category: .mentalEmotional, displayOrder: 10)
    ]

    // MARK: - Skin & Hair Symptoms (10)

    static let skinSymptoms: [Symptom] = [
        Symptom(name: "Acne", category: .skinHair, displayOrder: 1),
        Symptom(name: "Dry Skin", category: .skinHair, displayOrder: 2),
        Symptom(name: "Oily Skin", category: .skinHair, displayOrder: 3),
        Symptom(name: "Rashes", category: .skinHair, displayOrder: 4),
        Symptom(name: "Itchy Skin", category: .skinHair, displayOrder: 5),
        Symptom(name: "Hair Thinning", category: .skinHair, displayOrder: 6),
        Symptom(name: "Hair Loss", category: .skinHair, displayOrder: 7),
        Symptom(name: "Brittle Nails", category: .skinHair, displayOrder: 8),
        Symptom(name: "Facial Hair Growth", category: .skinHair, displayOrder: 9),
        Symptom(name: "Skin Sensitivity", category: .skinHair, displayOrder: 10)
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

    /// Count of symptoms per category
    static var symptomsPerCategory: Int { 10 }

    /// Total symptom count
    static var totalSymptomCount: Int { 60 }
}
