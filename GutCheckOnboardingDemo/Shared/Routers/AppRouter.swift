import SwiftUI
import Observation

@Observable
class AppRouter {
    
    // MARK: - Published State
    
    var currentFlow: AppFlow = .onboarding
    
    var isAuthenticated: Bool = false
    var hasCompletedOnboarding: Bool = false
    var hasSeenWelcome: Bool = false
    var hasCompletedGettingStarted: Bool = false
    
    let currentUserId: UUID
    
    // MARK: - Child Routers
    
    var onboardingRouter = OnboardingRouter()
    var mainAppRouter = MainAppRouter()
    
    // MARK: - Flow Management
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        currentFlow = .mainApp

        onboardingRouter.reset()
    }

    func completeGettingStarted() {
        hasCompletedGettingStarted = true
        // In production, this is where you'd save Getting Started answers to backend
        // For demo, just update the flag
    }

    // MARK: - Navigation Helpers

    func selectMainAppTab(_ tab: MainTab) {
        mainAppRouter.selectTab(tab)
    }

    func signIn() {
        isAuthenticated = true
        hasCompletedOnboarding = true
        currentFlow = .mainApp
    }
    
    func logout() {
        isAuthenticated = false
        hasCompletedOnboarding = false
        hasSeenWelcome = false
        hasCompletedGettingStarted = false
        currentFlow = .onboarding

        mainAppRouter.reset()
        onboardingRouter.reset()
    }
    
    // MARK: - Initialization
    
    init() {
        self.currentUserId = UUID()
        
        // Check if user has completed onboarding (e.g., from UserDefaults)
        // For now, always start with onboarding
        self.currentFlow = .mainApp
    }
}

// MARK: - App Flow Enum

enum AppFlow {
    case onboarding
    case mainApp
}
