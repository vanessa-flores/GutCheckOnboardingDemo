import Foundation

enum Mood: String, Codable, CaseIterable, Identifiable {
    case great
    case good
    case meh
    case rough
    case awful
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .great: return "great"
        case .good: return "good"
        case .meh: return "meh"
        case .rough: return "bad"
        case .awful: return "awful"
        }
    }
    
    var emoji: String {
        switch self {
        case .great: return "😄"
        case .good: return "🙂"
        case .meh: return "😐"
        case .rough: return "☹️"
        case .awful: return "😭"
        }
    }
}
