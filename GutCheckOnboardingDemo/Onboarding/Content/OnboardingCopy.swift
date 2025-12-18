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

    // MARK: - Screen 2: You’re in the right place
    
    struct Screen2 {
        static let headline = "You’re in the right place"
        static let body = "If you're experiencing any of these, you're not alone—and this isn't all in your head."
        static let buttonTitle = "This is me"
        
        static var symptomCategories: [SymptomCategory] {
            SymptomRepository.allCategories
        }
    }

    // MARK: - Screen 3: Gut-hormone connection
    
    struct Screen3 {
        static let headline = "There's a reason you're feeling this way"
        static let body = "Your gut and hormones are deeply connected. Research shows gut health directly impacts hormone regulation. When your gut struggles, your hormones often follow—and most health apps miss this."
        static let buttonTitle = "Tell me more"
        static let illustrationText = "Gut-hormone connection diagram"
    }

    // MARK: - Screen 4: Your body has its own patterns

    struct Screen4 {
        static let headline = "Your body has its own patterns"
        static let body = "Without tracking, symptoms feel random and overwhelming. But when you capture your baseline, patterns emerge—and patterns reveal what your body is trying to tell you."
        static let buttonTitle = "What's next?"
        static let illustrationText = "Line graph showing patterns"
    }

    // MARK: - Screen 5: Experiments

    struct Screen5 {
        static let headline = "Ready to experiment?"
        static let body = "Once you know your patterns, you can test what helps. Try small changes to your nutrition, sleep, and lifestyle — and track how your body responds. Together, we'll discover what actually helps ease your symptoms."
        static let buttonTitle = "Let's do it"
        static let illustrationText = "Line graph showing patterns"
    }

    // MARK: - Email Collection

    struct EmailCollection {
        static let headline = "Want help getting started?"
        static let body = "We’ll send a few emails to guide you:"
        static let buttonTitle = "Get started"
        static let secondaryButtonTitle = "Maybe later"
        static let emailPlaceholder = "your@email.com"
        static let errorMessage = "Please enter a valid email address"
    }
}
