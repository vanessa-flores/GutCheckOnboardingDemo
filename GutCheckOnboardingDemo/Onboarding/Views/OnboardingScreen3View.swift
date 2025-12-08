import SwiftUI

struct OnboardingScreen3View: View {
    var router: OnboardingRouter
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
                        Circle()
                            .fill(index == 2 ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(width: AppTheme.ComponentSizes.progressDotSize, height: AppTheme.ComponentSizes.progressDotSize)
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Your baseline matters")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("Tracking helps you see patterns you'd otherwise miss. Understanding where you're starting makes it possible to know what's actually working.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                            .padding(.bottom, AppTheme.Spacing.xxxl)
                        
                        IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeightCompact, text: "Line graph showing patterns")
                        
                        Button("That makes sense") {
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
        OnboardingScreen3View(router: OnboardingRouter())
    }
}
