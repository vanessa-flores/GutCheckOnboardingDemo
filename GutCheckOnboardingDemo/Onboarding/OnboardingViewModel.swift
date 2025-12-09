import SwiftUI
import Observation

@Observable
class OnboardingViewModel {
    
    /// Navigation
    var router: OnboardingRouter
    
    /// Screen 4 State (Symptoms)
    var selectedSymptoms: Set<Symptom> = []
    var otherText: String = ""
    
    /// Email Collection State
    var email: String = ""
    var showEmailError: Bool = false
    
    // MARK: - Private Properties
    
    private let onComplete: () -> Void
    
    // MARK: - Computed Properties
    
    var activeScreen: OnboardingScreen {
        router.activeScreen
    }
    
    var showsProgressDots: Bool {
        router.activeScreen.showsProgressDots
    }
    
    var progressIndex: Int? {
        router.activeScreen.progressIndex
    }
    
    // MARK: - Init
    
    init(
        router: OnboardingRouter = OnboardingRouter(),
        onComplete: @escaping () -> Void
    ) {
        self.router = router
        self.onComplete = onComplete
    }
    
    // MARK: - Actions
    
    func handlePrimaryAction() {
        switch router.activeScreen {
        case .emailCollection:
            handleEmailSubmit()
        default:
            router.goToNextScreen()
        }
    }
    
    func handleSkip() {
        switch router.activeScreen {
        case .emailCollection:
            completeOnboarding()
        default:
            router.skipToEmailCollection()
        }
    }
    
    func completeOnboarding() {
        onComplete()
    }
    
    // MARK: - Email Validation
    
    private func handleEmailSubmit() {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        
        if trimmed.isEmpty {
            completeOnboarding()
            return
        }
        
        if validateEmail(trimmed) {
            print("Saving email: \(trimmed)")
            completeOnboarding()
        } else {
            showEmailError = true
        }
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", AppTheme.Validation.emailRegex)
        return predicate.evaluate(with: email)
    }
}
