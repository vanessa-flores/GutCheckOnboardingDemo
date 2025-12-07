import SwiftUI

struct OnboardingScreen2View: View {
    var router: OnboardingRouter
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(index == 1 ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        IllustrationPlaceholder(height: 180, text: "Gut-hormone connection diagram")
                            .padding(.bottom, AppTheme.Spacing.xl)
                        
                        Text("Your gut and hormones are deeply connected")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("Research shows gut health directly impacts hormone regulation. When your gut is struggling, your hormones often follow.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                        
                        Button("This makes sense") {
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
        .navigationBarBackButtonHidden(false)
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
        OnboardingScreen2View(router: OnboardingRouter())
    }
}
