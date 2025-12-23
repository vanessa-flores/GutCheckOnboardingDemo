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

#Preview {
    RootView()
}
