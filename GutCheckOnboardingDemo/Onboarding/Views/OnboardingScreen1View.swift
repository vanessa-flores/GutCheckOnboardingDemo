import SwiftUI

struct OnboardingScreen1View: View {
    var router: OnboardingRouter
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator dots - below nav bar
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
                        Circle()
                            .fill(index == 0 ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(width: AppTheme.ComponentSizes.progressDotSize, height: AppTheme.ComponentSizes.progressDotSize)
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Your body is changing")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("New symptoms. Irregular cycles. Energy crashes. You're not imagining this—you're in hormonal transition.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                            .padding(.bottom, AppTheme.Spacing.xxxl)
                        
                        IllustrationPlaceholder(height: AppTheme.ComponentSizes.illustrationHeightCompact, text: "Small accent illustration")
                        
                        VStack(spacing: 0) {
                            Button("Tell me more") {
                                router.goToNextScreen()
                            }
                            .buttonStyle(AppTheme.PrimaryButtonStyle())
                            
                            Button(action: { router.showSignIn() }) {
                                Text("Already have an account? Sign in")
                                    .font(AppTheme.Typography.bodySmall)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            .padding(.top, AppTheme.Spacing.md)
                        }
                        .padding(.top, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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

// Placeholder view for illustration (rounded rectangle style)
struct IllustrationPlaceholder: View {
    let height: CGFloat
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.primaryAction.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.3))
                )
            
            Text(text)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(height: height)
    }
}

#Preview {
    NavigationStack {
        OnboardingScreen1View(router: OnboardingRouter())
    }
}
