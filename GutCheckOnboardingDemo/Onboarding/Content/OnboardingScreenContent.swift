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

// MARK: - Reusable Input Components

struct PlaceholderTextEditor: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
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

            if text.isEmpty {
                Text(placeholder)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .allowsHitTesting(false)
            }
        }
    }
}

struct StyledTextField: View {
    let placeholder: String
    @Binding var text: String
    var isError: Bool
    var isFocused: FocusState<Bool>.Binding?
    var onSubmit: () -> Void

    var body: some View {
        let base = TextField("", text: $text, prompt: Text(placeholder))
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
                    .stroke(isError ? AppTheme.Colors.error : AppTheme.Colors.textSecondary, lineWidth: 2)
            )
            .onSubmit { onSubmit() }

        if let isFocused {
            base
                .focused(isFocused)
        } else {
            base
        }
    }
}

// End reusable input components

// MARK: - Reusable Illustration Component

struct OnboardingIllustration: View {
    let height: CGFloat
    let text: String
    let isVisible: Bool
    let offset: CGFloat
    let bottomPadding: CGFloat?

    init(height: CGFloat, text: String, isVisible: Bool, offset: CGFloat, bottomPadding: CGFloat? = nil) {
        self.height = height
        self.text = text
        self.isVisible = isVisible
        self.offset = offset
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        IllustrationPlaceholder(height: height, text: text)
            .padding(.bottom, bottomPadding ?? 0)
            .onboardingAnimated(isVisible: isVisible, offset: offset)
    }
}

// End reusable illustration component

// MARK: - Screen Layout Scaffold

struct OnboardingScreenLayout<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
    }
}

// End screen layout scaffold

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
        OnboardingScreenLayout {
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

            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen1.illustrationText,
                isVisible: animationState.showIllustration,
                offset: animationState.contentOffset
            )
        }
    }
}

// MARK: - Screen 2 Content

struct Screen2ContentView: View {
    let animationState: OnboardingAnimationState

    var body: some View {
        OnboardingScreenLayout {
            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen2.illustrationText,
                isVisible: animationState.showIllustration,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

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
        OnboardingScreenLayout {
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

            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen3.illustrationText,
                isVisible: animationState.showIllustration,
                offset: animationState.contentOffset
            )
        }
    }
}

// MARK: - Screen 4 Content (Symptoms)

struct Screen4ContentView: View {
    let animationState: OnboardingAnimationState
    @Binding var selectedSymptoms: Set<Symptom>
    @Binding var otherText: String

    var body: some View {
        OnboardingScreenLayout {
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
        PlaceholderTextEditor(text: $otherText, placeholder: OnboardingCopy.Screen4.otherTextPlaceholder)
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
        OnboardingScreenLayout {
            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen5.illustrationText,
                isVisible: animationState.showIllustration,
                offset: animationState.contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

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
        OnboardingScreenLayout {
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
        StyledTextField(
            placeholder: OnboardingCopy.EmailCollection.emailPlaceholder,
            text: $email,
            isError: showEmailError,
            isFocused: isEmailFocused,
            onSubmit: onSubmit
        )
        .onChange(of: email) { _, _ in
            if showEmailError {
                showEmailError = false
            }
        }
    }
}

// MARK: - Component Previews

#Preview("Headline & Body Components") {
    OnboardingScreenLayout {
        OnboardingHeadline(text: "Sample Headline", isVisible: true, offset: 0)
        OnboardingBody(text: "Sample body text for previewing styles and spacing.", isVisible: true, offset: 0, bottomPadding: AppTheme.Spacing.xl)
    }
    .padding()
}

#Preview("Illustration Component") {
    OnboardingIllustration(
        height: AppTheme.ComponentSizes.illustrationHeight,
        text: "Illustration",
        isVisible: true,
        offset: 0,
        bottomPadding: AppTheme.Spacing.xl
    )
    .padding()
}

#Preview("PlaceholderTextEditor Component") {
    @State var text: String = ""
    return PlaceholderTextEditor(text: .constant(text), placeholder: "Enter details...")
        .padding()
}

#Preview("StyledTextField Component") {
    struct Wrapper: View {
        @State var text: String = ""
        @FocusState var focused: Bool
        var body: some View {
            StyledTextField(
                placeholder: "Email",
                text: $text,
                isError: false,
                isFocused: $focused,
                onSubmit: {}
            )
            .padding()
        }
    }
    return Wrapper()
}

// End component previews

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

