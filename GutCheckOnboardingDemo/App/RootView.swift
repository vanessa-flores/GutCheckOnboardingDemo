import SwiftUI

struct RootView: View {
    @Bindable private var appRouter = AppRouter()
    
    var body: some View {
        Group {
            switch appRouter.currentFlow {
            case .onboarding:
                OnboardingContainerView(onComplete: {
                    appRouter.completeOnboarding()
                })
                .sheet(isPresented: $appRouter.onboardingRouter.showingSignIn) {
                    SignInView(appRouter: appRouter)
                }
                
            case .mainApp:
                MainAppView(appRouter: appRouter)
            }
        }
    }
}

// MARK: - Main App View

struct MainAppView: View {
    @State var appRouter: AppRouter
    
    var body: some View {
        TabView(selection: $appRouter.mainAppRouter.selectedTab) {
            // Dashboard Tab
            DashboardView()
                .tabItem {
                    Label(
                        appRouter.mainAppRouter.selectedTab.title,
                        systemImage: appRouter.mainAppRouter.selectedTab.icon
                    )
                }
                .tag(MainTab.dashboard)
        }
    }
}

// MARK: - Placeholder Views

struct SignInView: View {
    var appRouter: AppRouter
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(AppTheme.Typography.title)
            
            Button("Sign In") {
                appRouter.signIn()
            }
            .buttonStyle(AppTheme.PrimaryButtonStyle())
            .padding()
        }
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.xl) {
                    Spacer()
                    
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.3))
                    
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Welcome to GutCheck")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                        
                        Text("Your tracking journey starts here")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("Dashboard features coming soon")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                        .padding(.bottom, AppTheme.Spacing.xxxl)
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
            .navigationTitle("GutCheck")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RootView()
}
