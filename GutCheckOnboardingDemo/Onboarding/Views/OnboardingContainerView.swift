import SwiftUI

// MARK: - Onboarding Container View

struct OnboardingContainerView: View {
    var appRouter: AppRouter
    @State private var router: OnboardingRouter

    // MARK: - Animation State

    @State private var contentOffset: CGFloat = 0
    @State private var showContent: Bool = true
    @State private var isAnimating: Bool = false
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
            showHeadline: showContent,
            showBody: showContent,
            showIllustration: showContent,
            showInteractiveContent: showContent,
            contentOffset: contentOffset
        )
    }

    private var slideDistance: CGFloat {
        UIScreen.main.bounds.width
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
            if !hasPerformedInitialAnimation && router.activeScreen == .screen1 {
                performInitialAnimation()
            }
        }
        .gesture(swipeBackGesture)
        .onChange(of: router.activeScreen) { _, _ in
            animateScreenTransition()
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
            EmptyView()

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
            Button(action: handlePrimaryAction) {
                Text(primaryButtonTitle)
            }
            .buttonStyle(AppTheme.PrimaryButtonStyle())
            .disabled(isAnimating)

            if let secondaryAction = secondaryButtonConfig {
                Button(action: secondaryAction.action) {
                    Text(secondaryAction.title)
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, AppTheme.Spacing.sm)
            } else {
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
                if value.translation.width > 100 && router.canGoBack && !isAnimating {
                    router.goBack()
                }
            }
    }

    // MARK: - Animations

    private func animateScreenTransition() {
        guard !isAnimating else { return }

        let direction = router.navigationDirection
        guard direction != .none else { return }

        isAnimating = true
        let isForward = direction == .forward

        // Slide out current content
        withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
            contentOffset = isForward ? -slideDistance : slideDistance
            showContent = false
        }

        // Slide in new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            contentOffset = isForward ? slideDistance : -slideDistance
            showContent = true

            withAnimation(.easeOut(duration: AppTheme.Animation.slideTransition)) {
                contentOffset = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.slideTransition) {
                isAnimating = false
            }
        }
    }

    private func performInitialAnimation() {
        hasPerformedInitialAnimation = true
        contentOffset = slideDistance

        withAnimation(.easeOut(duration: AppTheme.Animation.contentFadeIn)) {
            contentOffset = 0
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OnboardingContainerView(appRouter: AppRouter())
    }
}
