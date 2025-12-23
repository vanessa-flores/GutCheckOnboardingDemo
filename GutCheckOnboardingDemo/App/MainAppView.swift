import SwiftUI

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
