import SwiftUI

// MARK: - Shared Animation Modifier

struct OnboardingAnimated: ViewModifier {
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
    }
}

extension View {
    func onboardingAnimated(offset: CGFloat) -> some View {
        modifier(OnboardingAnimated(offset: offset))
    }
}

// MARK: - Reusable Text Components

struct OnboardingHeadline: View {
    let text: String
    let offset: CGFloat

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.title)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .tracking(AppTheme.Typography.titleTracking)
            .padding(.bottom, AppTheme.Spacing.lg)
            .onboardingAnimated(offset: offset)
    }
}

struct OnboardingBody: View {
    let text: String
    let offset: CGFloat
    let bottomPadding: CGFloat?

    init(text: String, offset: CGFloat, bottomPadding: CGFloat? = nil) {
        self.text = text
        self.offset = offset
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.bodyLarge)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .lineSpacing(10)
            .padding(.bottom, bottomPadding ?? 0)
            .onboardingAnimated(offset: offset)
    }
}

// MARK: - Reusable Illustration Component

struct OnboardingIllustration: View {
    let height: CGFloat
    let text: String
    let offset: CGFloat
    let bottomPadding: CGFloat?

    init(height: CGFloat, text: String, offset: CGFloat, bottomPadding: CGFloat? = nil) {
        self.height = height
        self.text = text
        self.offset = offset
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        IllustrationPlaceholder(height: height, text: text)
            .padding(.bottom, bottomPadding ?? 0)
            .onboardingAnimated(offset: offset)
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
            base.focused(isFocused)
        } else {
            base
        }
    }
}

// MARK: - Screen Layout Scaffold

struct OnboardingScreenLayout<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
    }
}

// MARK: - Screen 1 Content

struct Screen1ContentView: View {
    let contentOffset: CGFloat

    var body: some View {
        OnboardingScreenLayout {
            OnboardingHeadline(
                text: OnboardingCopy.Screen1.headline,
                offset: contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen1.body,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.xxxl
            )

            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen1.illustrationText,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Screen 2 Content

struct Screen2ContentView: View {
    let contentOffset: CGFloat

    var body: some View {
        OnboardingScreenLayout {
            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen2.illustrationText,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

            OnboardingHeadline(
                text: OnboardingCopy.Screen2.headline,
                offset: contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen2.body,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Screen 3 Content

struct Screen3ContentView: View {
    let contentOffset: CGFloat

    var body: some View {
        OnboardingScreenLayout {
            OnboardingHeadline(
                text: OnboardingCopy.Screen3.headline,
                offset: contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen3.body,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.xxxl
            )

            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeightCompact,
                text: OnboardingCopy.Screen3.illustrationText,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Screen 4 Content (Symptoms)

struct Screen4ContentView: View {
    let contentOffset: CGFloat
    @Binding var selectedSymptoms: Set<Symptom>
    @Binding var otherText: String

    var body: some View {
        OnboardingScreenLayout {
            OnboardingHeadline(
                text: OnboardingCopy.Screen4.headline,
                offset: contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen4.body,
                offset: contentOffset,
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
            .onboardingAnimated(offset: contentOffset)

            if selectedSymptoms.contains(.other) {
                PlaceholderTextEditor(text: $otherText, placeholder: OnboardingCopy.Screen4.otherTextPlaceholder)
                    .padding(.top, AppTheme.Spacing.sm)
                    .padding(.bottom, AppTheme.Spacing.sm)
                    .onboardingAnimated(offset: contentOffset)
            }
        }
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
    let contentOffset: CGFloat

    var body: some View {
        OnboardingScreenLayout {
            OnboardingIllustration(
                height: AppTheme.ComponentSizes.illustrationHeight,
                text: OnboardingCopy.Screen5.illustrationText,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

            OnboardingHeadline(
                text: OnboardingCopy.Screen5.headline,
                offset: contentOffset
            )

            OnboardingBody(
                text: OnboardingCopy.Screen5.body,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Email Collection Content

struct EmailCollectionContentView: View {
    let contentOffset: CGFloat
    @Binding var email: String
    @Binding var showEmailError: Bool
    var isEmailFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    var body: some View {
        OnboardingScreenLayout {
            OnboardingHeadline(
                text: OnboardingCopy.EmailCollection.headline,
                offset: contentOffset
            )
            .padding(.top, 100)

            OnboardingBody(
                text: OnboardingCopy.EmailCollection.body,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.xl
            )

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
            .onboardingAnimated(offset: contentOffset)

            if showEmailError {
                Text(OnboardingCopy.EmailCollection.errorMessage)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.top, AppTheme.Spacing.xs)
                    .onboardingAnimated(offset: contentOffset)
            }
        }
    }
}

// MARK: - Previews

#Preview("Screen 1") {
    Screen1ContentView(contentOffset: 0)
        .padding()
}

#Preview("Screen 2") {
    Screen2ContentView(contentOffset: 0)
        .padding()
}

#Preview("Screen 3") {
    Screen3ContentView(contentOffset: 0)
        .padding()
}

#Preview("Screen 4") {
    Screen4ContentView(
        contentOffset: 0,
        selectedSymptoms: .constant([.fatigue, .brainFog]),
        otherText: .constant("")
    )
    .padding()
}

#Preview("Screen 5") {
    Screen5ContentView(contentOffset: 0)
        .padding()
}

#Preview("Components") {
    VStack(spacing: 20) {
        OnboardingHeadline(text: "Sample Headline", offset: 0)
        OnboardingBody(text: "Sample body text.", offset: 0, bottomPadding: AppTheme.Spacing.xl)
        OnboardingIllustration(
            height: AppTheme.ComponentSizes.illustrationHeight,
            text: "Illustration",
            offset: 0
        )
    }
    .padding()
}
