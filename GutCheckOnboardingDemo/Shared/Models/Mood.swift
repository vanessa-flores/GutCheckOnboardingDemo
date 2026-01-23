import Foundation

enum Mood: String, Codable, CaseIterable, Identifiable {
    case great
    case good
    case okay
    case rough
    case awful
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .great: return "Great"
        case .good: return "Good"
        case .okay: return "Okay"
        case .rough: return "Rough"
        case .awful: return "Awful"
        }
    }
    
    var emoji: String {
        switch self {
        case .great: return "😄"
        case .good: return "🙂"
        case .okay: return "😐"
        case .rough: return "😟"
        case .awful: return "😞"
        }
    }
}
