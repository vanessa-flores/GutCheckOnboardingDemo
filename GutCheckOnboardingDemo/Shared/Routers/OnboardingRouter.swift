import SwiftUI
import Observation

/// Direction of navigation for animation purposes
enum NavigationDirection {
    case forward
    case backward
    case none
}

/// Handles navigation for screens 1-5 and email collection
@Observable
class OnboardingRouter {

    // MARK: - Published State

    var currentScreen: OnboardingScreen = .screen1
    var navigationPath: [OnboardingScreen] = [.screen1]
    var showingSignIn: Bool = false
    var navigationDirection: NavigationDirection = .none

    // MARK: - Computed Properties

    var activeScreen: OnboardingScreen {
        navigationPath.last ?? .screen1
    }

    var canGoBack: Bool {
        guard let current = navigationPath.last else { return false }
        return current != .screen1
    }

    // MARK: - Navigation Actions

    func goToNextScreen() {
        navigationDirection = .forward
        guard let currentIndex = navigationPath.last,
              let nextScreen = currentIndex.next else {
            // Reached end of onboarding, show email collection
            navigationPath.append(.emailCollection)
            return
        }
        navigationPath.append(nextScreen)
    }

    func goBack() {
        guard !navigationPath.isEmpty else { return }
        navigationDirection = .backward
        navigationPath.removeLast()
    }

    func skipToEmailCollection() {
        navigationDirection = .forward
        navigationPath.append(.emailCollection)
    }

    func showSignIn() {
        showingSignIn = true
    }

    func reset() {
        currentScreen = .screen1
        navigationPath = [.screen1]
        showingSignIn = false
        navigationDirection = .none
    }
}

// MARK: - Onboarding Screen Enum

enum OnboardingScreen: Hashable, Identifiable {
    case screen1  // "Your body is changing"
    case screen2  // "Your gut and hormones are deeply connected"
    case screen3  // "Your baseline matters"
    case screen4  // "What are you experiencing?"
    case screen5  // "Small experiments, real insights"
    case emailCollection

    var id: String {
        switch self {
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
        case .screen1: return .screen2
        case .screen2: return .screen3
        case .screen3: return .screen4
        case .screen4: return .screen5
        case .screen5: return .emailCollection
        case .emailCollection: return nil
        }
    }

    var previous: OnboardingScreen? {
        switch self {
        case .screen1: return nil
        case .screen2: return .screen1
        case .screen3: return .screen2
        case .screen4: return .screen3
        case .screen5: return .screen4
        case .emailCollection: return .screen5
        }
    }

    var progressIndex: Int? {
        switch self {
        case .screen1: return 0
        case .screen2: return 1
        case .screen3: return 2
        case .screen4: return 3
        case .screen5: return 4
        case .emailCollection: return nil
        }
    }

    var showsProgressDots: Bool {
        progressIndex != nil
    }

    var isLastContentScreen: Bool {
        return self == .screen5
    }
}
