import SwiftUI
import Observation

@Observable
class GettingStartedRouter {
    
    // MARK: - Published State

    var currentScreen: GettingStartedScreen = .goalsMotivations
    var navigationPath: [GettingStartedScreen] = [.goalsMotivations]
    
    // MARK: - Computed Properties

    var activeScreen: GettingStartedScreen {
        navigationPath.last ?? .goalsMotivations
    }
    
    var canGoBack: Bool {
        guard let current = navigationPath.last else { return false }
        return current != .goalsMotivations
    }
    
    // MARK: - Navigation Actions

    func goToNextScreen() {
        guard let currentIndex = navigationPath.last,
              let nextScreen = currentIndex.next else {
            // Reached end of getting started
            // TODO: - is this guard needed?
            return
        }
        navigationPath.append(nextScreen)
    }

    func goBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func reset() {
        currentScreen = .goalsMotivations
        navigationPath = [.goalsMotivations]
    }
}

// MARK: - Getting Started Screen

enum GettingStartedScreen: Hashable, Identifiable {
    case goalsMotivations
    case gutHealthAwareness
    case menstrualCycleStatus
    case symptomSelection


    var id: String {
        switch self {
        case .goalsMotivations: return "goalsMotivations"
        case .gutHealthAwareness: return "gutHealthAwareness"
        case .menstrualCycleStatus: return "menstrualCycleStatus"
        case .symptomSelection: return "symptomSelection"
        }
    }

    var next: GettingStartedScreen? {
        switch self {
        case .goalsMotivations: return .gutHealthAwareness
        case .gutHealthAwareness: return .menstrualCycleStatus
        case .menstrualCycleStatus: return .symptomSelection
        case .symptomSelection: return nil
        }
    }

    var previous: GettingStartedScreen? {
        switch self {
        case .goalsMotivations: return nil
        case .gutHealthAwareness: return .goalsMotivations
        case .menstrualCycleStatus: return .gutHealthAwareness
        case .symptomSelection: return .menstrualCycleStatus
        }
    }

    var progressIndex: Int {
        switch self {
        case .goalsMotivations: return 0
        case .gutHealthAwareness: return 1
        case .menstrualCycleStatus: return 2
        case .symptomSelection: return 3
        }
    }

    var isLastContentScreen: Bool {
        return self == .symptomSelection
    }
}
