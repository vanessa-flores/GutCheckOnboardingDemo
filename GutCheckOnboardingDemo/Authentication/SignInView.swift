import SwiftUI

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
