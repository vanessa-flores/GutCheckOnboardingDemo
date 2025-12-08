import Foundation

struct OnboardingCopy {

    // MARK: - Screen 1: Your body is changing

    struct Screen1 {
        static let headline = "Your body is changing"
        static let body = "New symptoms. Irregular cycles. Energy crashes. You're not imagining this—you're in hormonal transition."
        static let buttonTitle = "Tell me more"
        static let secondaryButtonTitle = "Already have an account? Sign in"
        static let illustrationText = "Small accent illustration"
    }

    // MARK: - Screen 2: Gut-hormone connection

    struct Screen2 {
        static let headline = "Your gut and hormones are deeply connected"
        static let body = "Research shows gut health directly impacts hormone regulation. When your gut struggles, your hormones often follow—and most health apps miss this."
        static let buttonTitle = "This makes sense"
        static let illustrationText = "Gut-hormone connection diagram"
    }

    // MARK: - Screen 3: Baseline matters

    struct Screen3 {
        static let headline = "Your baseline matters"
        static let body = "Tracking reveals patterns you'd otherwise miss. Understanding where you start makes it possible to see what actually helps your body."
        static let buttonTitle = "That makes sense"
        static let illustrationText = "Line graph showing patterns"
    }

    // MARK: - Screen 4: Symptoms selection

    struct Screen4 {
        static let headline = "What are you experiencing?"
        static let body = "Select what you're dealing with. This helps us understand where you're starting from."
        static let buttonTitle = "Continue"
        static let otherTextPlaceholder = "Describe your symptoms"
    }

    // MARK: - Screen 5: Experiments

    struct Screen5 {
        static let headline = "Small experiments, real insights"
        static let body = "Experiment with your nutrition, sleep, and lifestyle. Track how your body responds. Together, we'll discover what actually helps ease your symptoms."
        static let buttonTitle = "I'm ready"
        static let illustrationText = "Experimentation illustration\nA/B comparison"
    }

    // MARK: - Email Collection

    struct EmailCollection {
        static let headline = "Learn what's happening in your body"
        static let body = "Understand the hormonal changes you're experiencing and how gut health plays a bigger role than most doctors mention. Just a few emails to help you get started."
        static let buttonTitle = "Get started"
        static let secondaryButtonTitle = "Maybe later"
        static let emailPlaceholder = "your@email.com"
        static let errorMessage = "Please enter a valid email address"
    }
}
