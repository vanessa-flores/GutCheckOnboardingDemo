import SwiftUI

// MARK: - Onboarding Screen 4 View

struct OnboardingScreen4View: View {
    var router: OnboardingRouter
    
    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var otherText: String = ""
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
                        Circle()
                            .fill(index == 3 ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(width: AppTheme.ComponentSizes.progressDotSize, height: AppTheme.ComponentSizes.progressDotSize)
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("What are you experiencing?")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("Select what you're dealing with right now. This helps us understand your starting point.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                            .padding(.bottom, AppTheme.Spacing.xl)
                        
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
                        }
                        
                        Button("Continue") {
                            // TODO: Save selections to user_profile.starting_struggles
                            router.goToNextScreen()
                        }
                        .buttonStyle(AppTheme.PrimaryButtonStyle())
                        .padding(.top, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { router.skipToEmailCollection() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
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

// MARK: - Symptom Checkbox Component

struct SymptomCheckbox: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.ComponentSizes.checkboxCornerRadius)
                        .stroke(AppTheme.Colors.textSecondary, lineWidth: 2)
                        .frame(width: AppTheme.ComponentSizes.checkboxSize, height: AppTheme.ComponentSizes.checkboxSize)

                    if isSelected {
                        RoundedRectangle(cornerRadius: AppTheme.ComponentSizes.checkboxCornerRadius)
                            .fill(AppTheme.Colors.primaryAction)
                            .frame(width: AppTheme.ComponentSizes.checkboxSize, height: AppTheme.ComponentSizes.checkboxSize)

                        Image(systemName: "checkmark")
                            .font(.system(size: AppTheme.ComponentSizes.checkmarkIconSize, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }

                Text(label)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()
            }
            .padding(.vertical, AppTheme.Spacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.textSecondary.opacity(0.1))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    NavigationStack {
        OnboardingScreen4View(router: OnboardingRouter())
    }
}
