import SwiftUI

struct RootView: View {
    @Bindable private var appRouter = AppRouter()
    
    var body: some View {
        Group {
            switch appRouter.currentFlow {
            case .onboarding:
                ZStack {
                    OnboardingContainerView(onComplete: {
                        appRouter.completeOnboarding()
                    })

                    WelcomeScreenView(onComplete: {
                        appRouter.hasSeenWelcome = true
                    })
                    .opacity(appRouter.hasSeenWelcome ? 0 : 1)
                    .animation(.easeOut(duration: 0.3), value: appRouter.hasSeenWelcome)
                }
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
            DashboardView(appRouter: appRouter)
                .tabItem {
                    Label(
                        appRouter.mainAppRouter.selectedTab.title,
                        systemImage: appRouter.mainAppRouter.selectedTab.icon
                    )
                }
                .tag(MainTab.dashboard)
            
            LoggingContainerView(userId: appRouter.currentUserId, appRouter: appRouter)
                .tabItem {
                    Label(MainTab.log.title, systemImage: MainTab.log.icon)
                }
                .tag(MainTab.log)
        }
    }
}

// MARK: - Dashboard Route

enum DashboardRoute: Hashable {
    case gettingStarted
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
    @Bindable var appRouter: AppRouter

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                VStack(spacing: AppTheme.Spacing.xl) {
                    Spacer()

                    // Icon
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.3))

                    // Welcome message
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Welcome to GutCheck")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)

                        Text(appRouter.hasCompletedGettingStarted
                            ? "Your personalized tracker is ready"
                            : "Let's personalize your experience")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }

                    Spacer()

                    // Getting Started button (only show if not completed)
                    if !appRouter.hasCompletedGettingStarted {
                        NavigationLink(value: DashboardRoute.gettingStarted) {
                            HStack {
                                Text("Get Started")
                                    .font(AppTheme.Typography.button)

                                // Attention indicator (static dot)
                                Circle()
                                    .fill(AppTheme.Colors.primaryAction)
                                    .frame(width: 8, height: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(AppTheme.Colors.primaryAction.opacity(0.3), lineWidth: 4)
                                            .scaleEffect(1.5)
                                            .opacity(0.5)
                                    )
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppTheme.Colors.primaryAction)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                        }
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.xxxl)
                    } else {
                        // Placeholder for completed state
                        Text("Dashboard features coming soon")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                            .padding(.bottom, AppTheme.Spacing.xxxl)
                    }
                }
            }
            .navigationTitle("GutCheck")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .gettingStarted:
                    GettingStartedContainerView(
                        userId: appRouter.currentUserId,
                        onComplete: {
                            appRouter.completeGettingStarted()
                        }
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
