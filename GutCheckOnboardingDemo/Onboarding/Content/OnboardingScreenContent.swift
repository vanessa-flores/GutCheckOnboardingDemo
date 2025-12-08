import SwiftUI

// MARK: - Reusable Text Components

struct OnboardingHeadline: View {
    let text: String
    let isVisible: Bool
    let offset: CGFloat

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.title)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .tracking(AppTheme.Typography.titleTracking)
            .padding(.bottom, AppTheme.Spacing.lg)
            .opacity(isVisible ? 1 : 0)
            .offset(x: offset)
    }
}

struct OnboardingBody: View {
    let text: String
    let isVisible: Bool
    let offset: CGFloat
    let bottomPadding: CGFloat?

    init(text: String, isVisible: Bool, offset: CGFloat, bottomPadding: CGFloat? = nil) {
        self.text = text
        self.isVisible = isVisible
        self.offset = offset
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.bodyLarge)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .lineSpacing(10)
            .padding(.bottom, bottomPadding ?? 0)
            .opacity(isVisible ? 1 : 0)
            .offset(x: offset)
    }
}

// End reusable text components

// MARK: - Shared Animation Modifier

struct OnboardingAnimated: ViewModifier {
    let isVisible: Bool
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(x: offset)
    }
}

extension View {
    func onboardingAnimated(isVisible: Bool, offset: CGFloat) -> some View {
        modifier(OnboardingAnimated(isVisible: isVisible, offset: offset))
    }
}

struct OnboardingAnimationState {
    var showHeadline: Bool
    var showBody: Bool
    var showIllustration: Bool
    var showInteractiveContent: Bool
    var contentOffset: CGFloat
}

// MARK: - Screen 1 Content

struct Screen1ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingHeadline(
                text: OnboardingCopy.Screen1.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen1.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xxxl
            )

            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen1.illustrationText
            )
            .onboardingAnimated(isVisible: animationState.showIllustration, offset: animationState.contentOffset)
        }
    }
}

// MARK: - Screen 2 Content

struct Screen2ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen2.illustrationText
            )
            .padding(.bottom, AppTheme.Spacing.xl)
            .onboardingAnimated(isVisible: animationState.showIllustration, offset: animationState.contentOffset)

            OnboardingHeadline(
                text: OnboardingCopy.Screen2.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen2.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset
            )
        }
    }
}

// MARK: - Screen 3 Content

struct Screen3ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingHeadline(
                text: OnboardingCopy.Screen3.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen3.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xxxl
            )

            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen3.illustrationText
            )
            .onboardingAnimated(isVisible: animationState.showIllustration, offset: animationState.contentOffset)
        }
    }
}

// MARK: - Screen 4 Content (Symptoms)

struct Screen4ContentView: View {
    let animationState: OnboardingAnimationState
    @Binding var selectedSymptoms: Set<Symptom>
    @Binding var otherText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingHeadline(
                text: OnboardingCopy.Screen4.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen4.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

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
            .onboardingAnimated(isVisible: animationState.showInteractiveContent, offset: animationState.contentOffset)

            if selectedSymptoms.contains(.other) {
                otherSymptomTextEditor
                    .onboardingAnimated(isVisible: animationState.showInteractiveContent, offset: animationState.contentOffset)
            }
        }
    }

    private var otherSymptomTextEditor: some View {
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
                Text(OnboardingCopy.Screen4.otherTextPlaceholder)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .allowsHitTesting(false)
            }
        }
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.sm)
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
}

// MARK: - Screen 5 Content

struct Screen5ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen5.illustrationText
            )
            .padding(.bottom, AppTheme.Spacing.xl)
            .onboardingAnimated(isVisible: animationState.showIllustration, offset: animationState.contentOffset)

            OnboardingHeadline(
                text: OnboardingCopy.Screen5.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen5.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset
            )
        }
    }
}

// MARK: - Email Collection Content

struct EmailCollectionContentView: View {
    let animationState: OnboardingAnimationState
    @Binding var email: String
    @Binding var showEmailError: Bool
    var isEmailFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingHeadline(
                text: OnboardingCopy.EmailCollection.headline,
                isVisible: animationState.showHeadline,
                offset: animationState.contentOffset
            )
            .padding(.top, 100)

            OnboardingBody(
                text: OnboardingCopy.EmailCollection.body,
                isVisible: animationState.showBody,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

            emailTextField
                .onboardingAnimated(isVisible: animationState.showInteractiveContent, offset: animationState.contentOffset)

            if showEmailError {
                Text(OnboardingCopy.EmailCollection.errorMessage)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.top, AppTheme.Spacing.xs)
                    .onboardingAnimated(isVisible: animationState.showInteractiveContent, offset: animationState.contentOffset)
            }
        }
    }

    private var emailTextField: some View {
        TextField("", text: $email, prompt: Text(OnboardingCopy.EmailCollection.emailPlaceholder))
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
            .focused(isEmailFocused)
            .onChange(of: email) { _, _ in
                if showEmailError {
                    showEmailError = false
                }
            }
            .onSubmit {
                onSubmit()
            }
    }
}

// MARK: - Previews

#Preview("Screen 1") {
    Screen1ContentView(
        animationState: OnboardingAnimationState(
            showHeadline: true,
            showBody: true,
            showIllustration: true,
            showInteractiveContent: true,
            contentOffset: 0
        )
    )
    .padding()
}

#Preview("Screen 4") {
    Screen4ContentView(
        animationState: OnboardingAnimationState(
            showHeadline: true,
            showBody: true,
            showIllustration: true,
            showInteractiveContent: true,
            contentOffset: 0
        ),
        selectedSymptoms: .constant([.fatigue, .brainFog]),
        otherText: .constant("")
    )
    .padding()
}

