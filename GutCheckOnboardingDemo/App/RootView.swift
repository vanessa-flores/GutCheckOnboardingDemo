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

#Preview {
    RootView()
}
