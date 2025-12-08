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
            screen1Content
        case .screen2:
            screen2Content
        case .screen3:
            screen3Content
        case .screen4:
            screen4Content
        case .screen5:
            screen5Content
        case .emailCollection:
            emailCollectionContent
        }
    }

    // MARK: - Screen 1 Content

    private var screen1Content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your body is changing")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: contentOffset)

            Text("New symptoms. Irregular cycles. Energy crashes. You're not imagining this—you're in hormonal transition.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xxxl)
                .opacity(showBody ? 1 : 0)
                .offset(y: contentOffset)

            IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeightCompact, text: "Small accent illustration")
                .opacity(showIllustration ? 1 : 0)
                .offset(y: contentOffset)
        }
    }

    // MARK: - Screen 2 Content

    private var screen2Content: some View {
        VStack(alignment: .leading, spacing: 0) {
            IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeight, text: "Gut-hormone connection diagram")
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(showIllustration ? 1 : 0)
                .offset(y: contentOffset)

            Text("Your gut and hormones are deeply connected")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: contentOffset)

            Text("Research shows gut health directly impacts hormone regulation. When your gut struggles, your hormones often follow—and most health apps miss this.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .opacity(showBody ? 1 : 0)
                .offset(y: contentOffset)
        }
    }

    // MARK: - Screen 3 Content

    private var screen3Content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your baseline matters")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: contentOffset)

            Text("Tracking reveals patterns you'd otherwise miss. Understanding where you start makes it possible to see what actually helps your body.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xxxl)
                .opacity(showBody ? 1 : 0)
                .offset(y: contentOffset)

            IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeightCompact, text: "Line graph showing patterns")
                .opacity(showIllustration ? 1 : 0)
                .offset(y: contentOffset)
        }
    }

    // MARK: - Screen 4 Content (Symptoms)

    private var screen4Content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What are you experiencing?")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: contentOffset)

            Text("Select what you're dealing with. This helps us understand where you're starting from.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(showBody ? 1 : 0)
                .offset(y: contentOffset)

            VStack(spacing: 0) {
                ForEach(Symptom.allCases) { symptom in
                    SymptomCheckbox(
                        label: symptom.displayText,
                        isSelected: selectedSymptoms.contains(symptom)
                    ) {
                        toggleSymptom(symptom)
                    }
                }
            }
            .opacity(showInteractiveContent ? 1 : 0)
            .offset(x: contentOffset)

            if selectedSymptoms.contains(.other) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $otherText)
                        .frame(height: AppTheme.ComponentSizes.textEditorHeight)
                        .padding(AppTheme.Spacing.sm)
                        .background(Color.white)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.textSecondary, lineWidth: 2)
                        )
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .scrollContentBackground(.hidden)

                    if otherText.isEmpty {
                        Text("Describe your symptoms")
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.bottom, AppTheme.Spacing.sm)
                .opacity(showInteractiveContent ? 1 : 0)
                .offset(y: contentOffset)
            }
        }
    }

    // MARK: - Screen 5 Content

    private var screen5Content: some View {
        VStack(alignment: .leading, spacing: 0) {
            IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeight, text: "Experimentation illustration\nA/B comparison")
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(showIllustration ? 1 : 0)
                .offset(x: contentOffset)

            Text("Small experiments, real insights")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(x: contentOffset)

            Text("Experiment with your nutrition, sleep, and lifestyle. Track how your body responds. Together, we'll discover what actually helps ease your symptoms.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .opacity(showBody ? 1 : 0)
                .offset(x: contentOffset)
        }
    }

    // MARK: - Email Collection Content

    private var emailCollectionContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Learn what's happening in your body")
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.top, 100)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(showHeadline ? 1 : 0)
                .offset(x: contentOffset)

            Text("Understand the hormonal changes you're experiencing and how gut health plays a bigger role than most doctors mention. Just a few emails to help you get started.")
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(showBody ? 1 : 0)
                .offset(x: contentOffset)

            TextField("", text: $email, prompt: Text("your@email.com"))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tint(AppTheme.Colors.primaryAction)
                .padding(AppTheme.Spacing.md)
                .background(Color.white)
                .cornerRadius(AppTheme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(showEmailError ? AppTheme.Colors.error : AppTheme.Colors.textSecondary, lineWidth: 2)
                )
                .focused($isEmailFocused)
                .onChange(of: email) { oldValue, newValue in
                    if showEmailError {
                        showEmailError = false
                    }
                }
                .onSubmit {
                    handleEmailSubmit()
                }
                .opacity(showInteractiveContent ? 1 : 0)
                .offset(x: contentOffset)

            if showEmailError {
                Text("Please enter a valid email address")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.top, AppTheme.Spacing.xs)
                    .opacity(showInteractiveContent ? 1 : 0)
                    .offset(x: contentOffset)
            }
        }
    }

    // MARK: - Button Area

    @ViewBuilder
    private var buttonArea: some View {
        VStack(spacing: 0) {
            // Primary button - conditionally styled for initial animation
            if !hasPerformedInitialAnimation {
                // After initial animation - use standard button style
                Button(action: handlePrimaryAction) {
                    Text(primaryButtonTitle)
                        .opacity(showButton ? 1 : 0)
                }
                .buttonStyle(AppTheme.PrimaryButtonStyle())
                .disabled(isAnimating)
            } else {
                // During initial animation - custom style with animating background
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

            // Secondary link (screen-specific)
            if let secondaryAction = secondaryButtonConfig {
                Button(action: secondaryAction.action) {
                    Text(secondaryAction.title)
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .opacity(showButton ? 1 : 0)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    // MARK: - Button Configuration

    private var primaryButtonTitle: String {
        switch router.activeScreen {
        case .welcome: return ""
        case .screen1: return "Tell me more"
        case .screen2: return "This makes sense"
        case .screen3: return "That makes sense"
        case .screen4: return "Continue"
        case .screen5: return "I'm ready"
        case .emailCollection: return "Get started"
        }
    }

    private var secondaryButtonConfig: (title: String, action: () -> Void)? {
        switch router.activeScreen {
        case .screen1:
            return ("Already have an account? Sign in", { router.showSignIn() })
        case .emailCollection:
            return ("Maybe later", { appRouter.completeOnboarding() })
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

    private func toggleSymptom(_ symptom: Symptom) {
        if selectedSymptoms.contains(symptom) {
            selectedSymptoms.remove(symptom)
            if symptom == .other {
                otherText = ""
            }
        } else {
            selectedSymptoms.insert(symptom)
        }
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
        // Phase 1: Fade out current content
        withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeOut)) {
            contentOpacity = 0
            showHeadline = false
            showBody = false
            showIllustration = false
            showInteractiveContent = false
            showButton = false
        }

        // Phase 2: Staggered fade in new content
        let fadeOutDelay = AppTheme.Animation.contentFadeOut

        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDelay) {
            contentOpacity = 1
            contentOffset = 0

            // Stagger the fade-ins
            withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
                showHeadline = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.contentStagger) {
                withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
                    showBody = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.contentStagger * 2) {
                withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
                    showIllustration = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.contentStagger * 3) {
                withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
                    showInteractiveContent = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.contentStagger * 4) {
                withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
                    showButton = true
                }
                isAnimating = false
            }
        }
    }

    private func animateBackward() {
        let slideDistance: CGFloat = UIScreen.main.bounds.width

        // Slide current content out to the right
        withAnimation(.easeInOut(duration: AppTheme.Animation.slideTransition)) {
            contentOffset = slideDistance
            contentOpacity = 0
        }

        // After slide out, reset and slide in from left
        DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.slideTransition) {
            // Reset position to left side (off-screen)
            contentOffset = -slideDistance
            showHeadline = true
            showBody = true
            showIllustration = true
            showInteractiveContent = true
            showButton = true
            contentOpacity = 1

            // Slide in from left
            withAnimation(.easeInOut(duration: AppTheme.Animation.slideTransition)) {
                contentOffset = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.slideTransition) {
                isAnimating = false
            }
        }
    }
    
    private func performInitialAnimation() {
        hasPerformedInitialAnimation = true
        
        // Start with everything hidden and offset below
        showHeadline = false
        showBody = false
        showIllustration = false
        showInteractiveContent = false
        showButton = false
        contentOpacity = 0
        toolbarOpacity = 0
        buttonBackgroundOpacity = 0
        contentOffset = 30  // Start 30pt below (positive = down)
        
        // Everything slides up from bottom while fading in
        withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
            showHeadline = true
            showBody = true
            showIllustration = true
            showInteractiveContent = true
            showButton = true
            contentOpacity = 1
            toolbarOpacity = 1
            buttonBackgroundOpacity = 1
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
