import Foundation

// MARK: - Symptom Category

enum SymptomCategory: String, Codable, CaseIterable, Identifiable {
    case digestiveGutHealth = "Digestive & Gut Health"
    case cycleHormonal = "Cycle & Hormonal"
    case energyMoodMental = "Energy, Mood & Mental Clarity"
    case sleepTemperature = "Sleep & Temperature"
    case physicalPain = "Physical & Pain"
    case skinHairNails = "Skin, Hair & Nails"
    case sensory = "Sensory"
    case urogenital = "Urogenital"
    case otherPhysical = "Other Physical Symptoms"

    var id: String { rawValue }

    var displayOrder: Int {
        switch self {
        case .digestiveGutHealth: return 0
        case .cycleHormonal: return 1
        case .energyMoodMental: return 2
        case .sleepTemperature: return 3
        case .physicalPain: return 4
        case .skinHairNails: return 5
        case .sensory: return 6
        case .urogenital: return 7
        case .otherPhysical: return 8
        }
    }
    
    var isFeatured: Bool {
        switch self {
        case .digestiveGutHealth, .cycleHormonal, .energyMoodMental, .sleepTemperature: return true
        default: return false
        }
    }
}
