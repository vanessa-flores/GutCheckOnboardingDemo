import SwiftUI
import Observation

@Observable
class AppRouter {
    
    // MARK: - Published State
    
    var currentFlow: AppFlow = .onboarding
    
    var isAuthenticated: Bool = false
    var hasCompletedOnboarding: Bool = false
    
    // MARK: - Child Routers
    
    let onboardingRouter = OnboardingRouter()
    let mainAppRouter = MainAppRouter()
    
    // MARK: - Flow Management
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        currentFlow = .mainApp
        
        onboardingRouter.reset()
    }
    
    func signIn() {
        isAuthenticated = true
        hasCompletedOnboarding = true
        currentFlow = .mainApp
    }
    
    func logout() {
        isAuthenticated = false
        hasCompletedOnboarding = false
        currentFlow = .onboarding
        
        mainAppRouter.reset()
        
        onboardingRouter.resetForReturningUser()
    }
    
    // MARK: - Initialization
    
    init() {
        // Check if user has completed onboarding (e.g., from UserDefaults)
        // For now, always start with onboarding
        self.currentFlow = .onboarding
    }
}

// MARK: - App Flow Enum

enum AppFlow {
    case onboarding
    case mainApp
}
