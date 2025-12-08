import Foundation

/// User symptoms for onboarding questionnaire (Screen 4)
enum Symptom: String, CaseIterable, Identifiable {
    case severePMS = "Severe PMS"
    case migraines = "Migraines or headaches"
    case fatigue = "Fatigue or low energy"
    case brainFog = "Brain fog"
    case anxietyMoodSwings = "Anxiety or mood swings"
    case sleepIssues = "Sleep issues"
    case digestiveProblems = "Digestive problems"
    case irregularCycles = "Irregular cycles"
    case nightSweats = "Night sweats or hot flashes"
    case other = "Other"

    var id: String { rawValue }

    var displayText: String { rawValue }

    var requiresTextInput: Bool {
        self == .other
    }
}
