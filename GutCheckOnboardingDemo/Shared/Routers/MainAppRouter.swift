import SwiftUI
import Observation

@Observable
class MainAppRouter {
    
    // MARK: - Published State
    
    var selectedTab: MainTab = .dashboard
    
    // MARK: - Tab Selection
    
    func selectTab(_ tab: MainTab) {
        selectedTab = tab
    }
    
    func reset() {
        selectedTab = .dashboard
    }
}

// MARK: - Main Tab Enum

enum MainTab: String, CaseIterable, Identifiable {
    case dashboard
    case log
    case profile
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .log: return "Log"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "list.bullet.below.rectangle"
        case .log: return "pencil.and.list.clipboard"
        case .profile: return "person.crop.circle"
        }
    }
}
