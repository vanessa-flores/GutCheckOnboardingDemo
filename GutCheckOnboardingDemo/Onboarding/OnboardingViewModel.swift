import SwiftUI
import Observation

@Observable
class OnboardingViewModel {
    
    // Navigation
    var router: OnboardingRouter
    
    // Screen 4 State (Symptoms)
    var selectedSymptoms: Set<Symptom> = []
    var otherText: String = ""
    
    // Email Collection State
    var email: String = ""
    var showEmailError: Bool = false
    
    // Animation State
    var contentOffset: CGFloat = 0
    var showContent: Bool = true
    let screenWidth = UIScreen.main.bounds.width
    
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
    
    var canGoBack: Bool {
        router.canGoBack
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
            animateForward {
                self.router.goToNextScreen()
            }
        }
    }
    
    func goBack() {
        animateBackward {
            self.router.goBack()
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
    
    // MARK: - Animations
    
    private func animateForward(completion: @escaping () -> Void) {
        // Slide current content out to left
        withAnimation(.easeOut(duration: 0.2)) {
            contentOffset = -screenWidth
        }
        
        // After slide out, change screen and prepare new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion()
            self.contentOffset = self.screenWidth  // Position new content off-screen right
            
            // Slide new content in from right
            withAnimation(.easeOut(duration: 0.2)) {
                self.contentOffset = 0
            }
        }
    }
    
    private func animateBackward(completion: @escaping () -> Void) {
        // Slide current content out to right
        withAnimation(.easeOut(duration: 0.2)) {
            contentOffset = screenWidth
        }
        
        // After slide out, change screen and prepare new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion()
            self.contentOffset = -self.screenWidth  // Position new content off-screen left
            
            // Slide new content in from left
            withAnimation(.easeOut(duration: 0.2)) {
                self.contentOffset = 0
            }
        }
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
