import SwiftUI

// MARK: - Main App View

struct MainAppView: View {
    @State var appRouter: AppRouter

    var body: some View {
        TabView(selection: $appRouter.mainAppRouter.selectedTab) {
            DashboardView(appRouter: appRouter)
                .tabItem {
                    Label(MainTab.dashboard.title, systemImage: MainTab.dashboard.icon)
                }
                .tag(MainTab.dashboard)
            
            LoggingHubView(userId: appRouter.currentUserId, appRouter: appRouter)
                .tabItem {
                    Label(MainTab.log.title, systemImage: MainTab.log.icon)
                }
                .tag(MainTab.log)
            
            ProfileView(appRouter: appRouter)
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
        }
    }
}
