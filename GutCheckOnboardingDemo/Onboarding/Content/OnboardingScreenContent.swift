import SwiftUI

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
            Text(OnboardingCopy.Screen1.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen1.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xxxl)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)

            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen1.illustrationText
            )
            .opacity(animationState.showIllustration ? 1 : 0)
            .offset(x: animationState.contentOffset)
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
            .opacity(animationState.showIllustration ? 1 : 0)
            .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen2.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen2.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)
        }
    }
}

// MARK: - Screen 3 Content

struct Screen3ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(OnboardingCopy.Screen3.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen3.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xxxl)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)

            IllustrationPlaceholder(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen3.illustrationText
            )
            .opacity(animationState.showIllustration ? 1 : 0)
            .offset(x: animationState.contentOffset)
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
            Text(OnboardingCopy.Screen4.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen4.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)

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
            .opacity(animationState.showInteractiveContent ? 1 : 0)
            .offset(x: animationState.contentOffset)

            if selectedSymptoms.contains(.other) {
                otherSymptomTextEditor
                    .opacity(animationState.showInteractiveContent ? 1 : 0)
                    .offset(x: animationState.contentOffset)
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
            .opacity(animationState.showIllustration ? 1 : 0)
            .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen5.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.Screen5.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)
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
            Text(OnboardingCopy.EmailCollection.headline)
                .font(AppTheme.Typography.title)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tracking(AppTheme.Typography.titleTracking)
                .padding(.top, 100)
                .padding(.bottom, AppTheme.Spacing.lg)
                .opacity(animationState.showHeadline ? 1 : 0)
                .offset(x: animationState.contentOffset)

            Text(OnboardingCopy.EmailCollection.body)
                .font(AppTheme.Typography.bodyLarge)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineSpacing(10)
                .padding(.bottom, AppTheme.Spacing.xl)
                .opacity(animationState.showBody ? 1 : 0)
                .offset(x: animationState.contentOffset)

            emailTextField
                .opacity(animationState.showInteractiveContent ? 1 : 0)
                .offset(x: animationState.contentOffset)

            if showEmailError {
                Text(OnboardingCopy.EmailCollection.errorMessage)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.top, AppTheme.Spacing.xs)
                    .opacity(animationState.showInteractiveContent ? 1 : 0)
                    .offset(x: animationState.contentOffset)
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
