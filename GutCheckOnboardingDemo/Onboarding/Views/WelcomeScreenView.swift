import SwiftUI

struct WelcomeScreenView: View {
    let onComplete: () -> Void
    @State private var showAppName = false
    @State private var showTagline = false
    @State private var showAccentLine = false
    @State private var fadeOutScreen = false
    
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
        .opacity(fadeOutScreen ? 0 : 1)
        .onAppear {
            // App name fades in (0.8s)
            withAnimation(.easeOut(duration: AppTheme.Animation.welcomeAppNameDuration)) {
                showAppName = true
            }

            // Tagline and accent line fade in after 1.2s delay (0.8s duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.welcomeTaglineDelay) {
                withAnimation(.easeOut(duration: AppTheme.Animation.welcomeTaglineDuration)) {
                    showTagline = true
                    showAccentLine = true
                }
            }

            // Start fade AND trigger navigation together at 3.7s
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                withAnimation(.easeOut(duration: 0.3)) {
                    fadeOutScreen = true
                }

                // Call after fade animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onComplete()
                }
            }

        }
    }
}

#Preview {
    WelcomeScreenView(onComplete: {})
}
