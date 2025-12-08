import SwiftUI

// MARK: - Onboarding Container View

struct OnboardingContainerView: View {
    var appRouter: AppRouter
    @State private var router: OnboardingRouter

    // MARK: - Animation State

    @State private var contentOpacity: Double = 1.0
    @State private var contentOffset: CGFloat = 0
    @State private var toolbarOpacity: Double = 1.0
    @State private var buttonBackgroundOpacity: Double = 1.0
    @State private var isAnimating: Bool = false

    // Staggered fade-in states
    @State private var showHeadline: Bool = true
    @State private var showBody: Bool = true
    @State private var showIllustration: Bool = true
    @State private var showInteractiveContent: Bool = true
    @State private var showButton: Bool = true
    @State private var hasPerformedInitialAnimation: Bool = false

    // MARK: - Screen 4 State (Symptoms)

    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var otherText: String = ""

    // MARK: - Email Collection State

    @State private var email: String = ""
    @State private var showEmailError: Bool = false
    @FocusState private var isEmailFocused: Bool

    // MARK: - Computed Properties

    private var animationState: OnboardingAnimationState {
        OnboardingAnimationState(
            showHeadline: showHeadline,
            showBody: showBody,
            showIllustration: showIllustration,
            showInteractiveContent: showInteractiveContent,
            contentOffset: contentOffset
        )
    }

    // MARK: - Init

    init(appRouter: AppRouter) {
        self.appRouter = appRouter
        self._router = State(initialValue: appRouter.onboardingRouter)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress dots (fixed at top, only for screens 1-5)
                if router.activeScreen.showsProgressDots {
                    progressDotsView
                        .opacity(contentOpacity)
                }

                // Scrollable content area
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        screenContent
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }

                // Fixed button area at bottom
                buttonArea
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
            }
        }
        .onAppear {
            // Detect first appearance from welcome screen
            if !hasPerformedInitialAnimation && router.activeScreen == .screen1 {
                performInitialAnimation()
            }
        }
        .gesture(swipeBackGesture)
        .onChange(of: router.activeScreen) { oldValue, newValue in
            animateTransition(from: oldValue, to: newValue)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if router.canGoBack {
                    Button(action: { router.goBack() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: handleSkip) {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .opacity(toolbarOpacity)
            }
        }
    }

    // MARK: - Progress Dots

    private var progressDotsView: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
                Circle()
                    .fill(index == router.activeScreen.progressIndex ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                    .frame(width: AppTheme.ComponentSizes.progressDotSize, height: AppTheme.ComponentSizes.progressDotSize)
            }
        }
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.md)
    }

    // MARK: - Screen Content

    @ViewBuilder
    private var screenContent: some View {
        switch router.activeScreen {
        case .welcome:
            EmptyView() // Welcome is handled separately

        case .screen1:
            Screen1ContentView(animationState: animationState)

        case .screen2:
            Screen2ContentView(animationState: animationState)

        case .screen3:
            Screen3ContentView(animationState: animationState)

        case .screen4:
            Screen4ContentView(
                animationState: animationState,
                selectedSymptoms: $selectedSymptoms,
                otherText: $otherText
            )

        case .screen5:
            Screen5ContentView(animationState: animationState)

        case .emailCollection:
            EmailCollectionContentView(
                animationState: animationState,
                email: $email,
                showEmailError: $showEmailError,
                isEmailFocused: $isEmailFocused,
                onSubmit: handleEmailSubmit
            )
        }
    }

    // MARK: - Button Area

    @ViewBuilder
    private var buttonArea: some View {
        VStack(spacing: 0) {
            // Primary button - conditionally styled for initial animation
            if hasPerformedInitialAnimation {
                // After initial animation - use standard button style (solid background)
                Button(action: handlePrimaryAction) {
                    Text(primaryButtonTitle)
                        .opacity(showButton ? 1 : 0)
                }
                .buttonStyle(AppTheme.PrimaryButtonStyle())
                .disabled(isAnimating)
            } else {
                // During initial animation ONLY - custom style with animating background
                Button(action: handlePrimaryAction) {
                    Text(primaryButtonTitle)
                        .font(AppTheme.Typography.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            AppTheme.Colors.primaryAction
                                .opacity(buttonBackgroundOpacity)
                        )
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .opacity(showButton ? 1 : 0)
                }
                .disabled(isAnimating)
            }

            // Secondary button area - always reserve space, but conditionally show button
            if let secondaryAction = secondaryButtonConfig {
                Button(action: secondaryAction.action) {
                    Text(secondaryAction.title)
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .opacity(showButton ? 1 : 0)
            } else {
                // Reserve space even when there's no secondary button
                Spacer()
                    .frame(height: 28)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
    }

    // MARK: - Button Configuration

    private var primaryButtonTitle: String {
        switch router.activeScreen {
        case .welcome: return ""
        case .screen1: return OnboardingCopy.Screen1.buttonTitle
        case .screen2: return OnboardingCopy.Screen2.buttonTitle
        case .screen3: return OnboardingCopy.Screen3.buttonTitle
        case .screen4: return OnboardingCopy.Screen4.buttonTitle
        case .screen5: return OnboardingCopy.Screen5.buttonTitle
        case .emailCollection: return OnboardingCopy.EmailCollection.buttonTitle
        }
    }

    private var secondaryButtonConfig: (title: String, action: () -> Void)? {
        switch router.activeScreen {
        case .screen1:
            return (OnboardingCopy.Screen1.secondaryButtonTitle, { router.showSignIn() })
        case .emailCollection:
            return (OnboardingCopy.EmailCollection.secondaryButtonTitle, { appRouter.completeOnboarding() })
        default:
            return nil
        }
    }

    // MARK: - Actions

    private func handlePrimaryAction() {
        guard !isAnimating else { return }

        switch router.activeScreen {
        case .emailCollection:
            handleEmailSubmit()
        default:
            router.goToNextScreen()
        }
    }

    private func handleSkip() {
        switch router.activeScreen {
        case .emailCollection:
            appRouter.completeOnboarding()
        default:
            router.skipToEmailCollection()
        }
    }

    private func handleEmailSubmit() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        if trimmedEmail.isEmpty {
            appRouter.completeOnboarding()
            return
        }

        if isValidEmail(trimmedEmail) {
            print("Saving email: \(trimmedEmail)")
            appRouter.completeOnboarding()
        } else {
            showEmailError = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", AppTheme.Validation.emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Swipe Gesture

    private var swipeBackGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                // Swipe right to go back
                if value.translation.width > 100 && router.canGoBack && !isAnimating {
                    router.goBack()
                }
            }
    }

    // MARK: - Animations

    private func animateTransition(from oldScreen: OnboardingScreen, to newScreen: OnboardingScreen) {
        guard !isAnimating else { return }
        isAnimating = true

        let direction = router.navigationDirection

        if direction == .forward {
            animateForward()
        } else if direction == .backward {
            animateBackward()
        } else {
            // No animation, just show content
            isAnimating = false
        }
    }

    private func animateForward() {
        let slideDistance = UIScreen.main.bounds.width

        // Hide content and slide current screen out to the left
        withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
            contentOffset = -slideDistance
            showHeadline = false
            showBody = false
            showIllustration = false
            showInteractiveContent = false
        }

        // Almost immediately prepare and slide in new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Position new content off-screen to the right
            contentOffset = slideDistance

            // Show and slide in new content
            withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
                showHeadline = true
                showBody = true
                showIllustration = true
                showInteractiveContent = true
                contentOffset = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.slideTransition) {
                isAnimating = false
            }
        }
    }

    private func animateBackward() {
        let slideDistance = UIScreen.main.bounds.width

        // Old content slides out to the right while new content slides in from left (overlap)
        withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
            contentOffset = slideDistance  // Slide current content right and out
        }

        // Immediately after starting the slide out, prepare and slide in previous content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Reset position to left side (off-screen) for previous content
            contentOffset = -slideDistance
            showHeadline = true
            showBody = true
            showIllustration = true
            showInteractiveContent = true

            withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
                contentOffset = 0  // Slide previous content in from left
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.slideTransition) {
                isAnimating = false
            }
        }
    }

    private func performInitialAnimation() {
        hasPerformedInitialAnimation = true

        // Start with content hidden and offset to the right (off-screen)
        showHeadline = true
        showBody = true
        showIllustration = true
        showInteractiveContent = true
        showButton = true
        contentOpacity = 1  // Progress dots visible immediately
        toolbarOpacity = 1  // X button visible immediately
        buttonBackgroundOpacity = 1  // Button background visible immediately
        contentOffset = UIScreen.main.bounds.width  // Start off-screen to the right

        // Content slides in from right (no fade, pure slide)
        withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
            contentOffset = 0  // Slide to final position
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OnboardingContainerView(appRouter: AppRouter())
    }
}
