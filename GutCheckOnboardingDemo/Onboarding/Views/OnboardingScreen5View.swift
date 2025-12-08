import SwiftUI

struct OnboardingScreen5View: View {
    var router: OnboardingRouter
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
                        Circle()
                            .fill(index == 4 ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(width: AppTheme.ComponentSizes.progressDotSize, height: AppTheme.ComponentSizes.progressDotSize)
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeight, text: "Experimentation illustration\nA/B comparison")
                            .padding(.bottom, AppTheme.Spacing.xl)
                        
                        Text("Experiments reveal patterns")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("Try small changes. We help you track it. Together, we'll discover what actually helps your body thrive.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                        
                        Button("Let's start") {
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
}

#Preview {
    NavigationStack {
        OnboardingScreen5View(router: OnboardingRouter())
    }
}
