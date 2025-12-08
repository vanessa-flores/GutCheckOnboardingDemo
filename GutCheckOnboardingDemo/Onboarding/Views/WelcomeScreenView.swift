import SwiftUI

struct WelcomeScreenView: View {
    var router: OnboardingRouter
    @State private var showAppName = false
    @State private var showTagline = false
    @State private var showAccentLine = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // App name - fades in first (0.8s duration)
                Text("Meet GutCheck")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .tracking(AppTheme.Typography.largeTitleTracking)
                    .lineSpacing(6)
                    .opacity(showAppName ? 1 : 0)
                    .offset(y: showAppName ? 0 : 10)
                
                // Tagline - fades in after 1.2s stagger delay (0.6s duration)
                Text("Your partner in hormonal transition")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.top, AppTheme.Spacing.md)
                    .opacity(showTagline ? 1 : 0)
                    .offset(y: showTagline ? 0 : 10)
                
                // Accent line - fades in with tagline (0.6s duration)
                Rectangle()
                    .fill(AppTheme.Colors.primaryAction.opacity(0.6))
                    .frame(width: 40, height: 2)
                    .cornerRadius(1)
                    .padding(.top, AppTheme.Spacing.xl)
                    .opacity(showAccentLine ? 1 : 0)
                    .offset(y: showAccentLine ? 0 : 10)
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.xxxl)
        }
        .onAppear {
            // App name fades in
            withAnimation(.easeOut(duration: AppTheme.Animation.welcomeAppNameDuration)) {
                showAppName = true
            }

            // Tagline and accent line fade in after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.welcomeTaglineDelay) {
                withAnimation(.easeOut(duration: AppTheme.Animation.welcomeTaglineDuration)) {
                    showTagline = true
                    showAccentLine = true
                }
            }

            // Auto-advance after total duration
            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.welcomeAutoAdvanceDelay) {
                router.advanceFromWelcome()
            }
        }
    }
}

#Preview {
    WelcomeScreenView(router: OnboardingRouter())
}
