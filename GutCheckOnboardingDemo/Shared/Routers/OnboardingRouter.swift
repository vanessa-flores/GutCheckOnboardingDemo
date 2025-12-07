import SwiftUI
import Observation

/// Handles: Welcome → Screens 1-5 → Email Collection → Dashboard
@Observable
class OnboardingRouter {
    
    // MARK: - Published State
    
    var currentScreen: OnboardingScreen = .welcome
    var navigationPath: [OnboardingScreen] = []
    var hasSeenWelcome: Bool = false
    var showingSignIn: Bool = false
    
    // MARK: - Navigation Actions
    
    func advanceFromWelcome() {
        hasSeenWelcome = true
        navigationPath.append(.screen1)
    }
    
    func goToNextScreen() {
        guard let currentIndex = navigationPath.last,
              let nextScreen = currentIndex.next else {
            // Reached end of onboarding, show email collection
            navigationPath.append(.emailCollection)
            return
        }
        navigationPath.append(nextScreen)
    }
    
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func skipToEmailCollection() {
        navigationPath.append(.emailCollection)
    }
    
    func showSignIn() {
        showingSignIn = true
    }
    
    func completeOnboarding() {
        // This will trigger AppRouter to transition to main app
        // The actual transition is handled by AppRouter.completeOnboarding()
    }
    
    func reset() {
        currentScreen = .welcome
        navigationPath = []
        hasSeenWelcome = false
        showingSignIn = false
    }
    
    func resetForReturningUser() {
        currentScreen = .screen1
        navigationPath = [.screen1]
        hasSeenWelcome = true
        showingSignIn = false
    }
}

// MARK: - Onboarding Screen Enum

enum OnboardingScreen: Hashable, Identifiable {
    case welcome
    case screen1  // "You're in transition"
    case screen2  // "Your gut and hormones are deeply connected"
    case screen3  // "Your baseline matters"
    case screen4  // "What are you experiencing?"
    case screen5  // "Experiments reveal patterns"
    case emailCollection
    
    var id: String {
        switch self {
        case .welcome: return "welcome"
        case .screen1: return "screen1"
        case .screen2: return "screen2"
        case .screen3: return "screen3"
        case .screen4: return "screen4"
        case .screen5: return "screen5"
        case .emailCollection: return "emailCollection"
        }
    }
    
    var next: OnboardingScreen? {
        switch self {
        case .welcome: return .screen1
        case .screen1: return .screen2
        case .screen2: return .screen3
        case .screen3: return .screen4
        case .screen4: return .screen5
        case .screen5: return .emailCollection
        case .emailCollection: return nil
        }
    }
    
    var isLastContentScreen: Bool {
        return self == .screen5
    }
}
