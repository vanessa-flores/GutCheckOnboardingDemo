import SwiftUI

struct RootView: View {
    @Bindable private var appRouter = AppRouter()
    
    var body: some View {
        Group {
            switch appRouter.currentFlow {
            case .onboarding:
                OnboardingFlowView(appRouter: appRouter)
            case .mainApp:
                MainAppView(appRouter: appRouter)
            }
        }
    }
}

// MARK: - Onboarding Flow View

struct OnboardingFlowView: View {
    @State var appRouter: AppRouter
    
    var body: some View {
        NavigationStack(path: $appRouter.onboardingRouter.navigationPath) {
            WelcomeScreenView(router: appRouter.onboardingRouter)
                .navigationDestination(for: OnboardingScreen.self) { screen in
                    onboardingDestination(for: screen)
                }
        }
        .sheet(isPresented: $appRouter.onboardingRouter.showingSignIn) {
            SignInView(appRouter: appRouter)
        }
    }
    
    @ViewBuilder
    private func onboardingDestination(for screen: OnboardingScreen) -> some View {
        switch screen {
        case .welcome:
            WelcomeScreenView(router: appRouter.onboardingRouter)
            
        case .screen1:
            OnboardingScreen1View(router: appRouter.onboardingRouter)
            
        case .screen2:
            OnboardingScreen2View(router: appRouter.onboardingRouter)
            
        case .screen3:
            OnboardingScreen3View(router: appRouter.onboardingRouter)
            
        case .screen4:
            OnboardingScreen4View(router: appRouter.onboardingRouter)
            
        case .screen5:
            OnboardingScreen5View(router: appRouter.onboardingRouter)
            
        case .emailCollection:
            EmailCollectionView(appRouter: appRouter)
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
            VStack {
                Text("Dashboard")
                    .font(AppTheme.Typography.largeTitle)
                
                Text("Your gut & hormone tracking home")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .navigationTitle("GutCheck")
        }
    }
}

#Preview {
    RootView()
}
