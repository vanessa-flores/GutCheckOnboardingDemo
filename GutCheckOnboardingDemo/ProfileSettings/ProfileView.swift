import SwiftUI

// MARK: - Profile View

struct ProfileView: View {
    @State var appRouter: AppRouter
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    // Placeholder content
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.3))
                        
                        Text("Profile")
                            .font(AppTheme.Typography.title2)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Text("Profile settings and preferences coming soon")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                }
                .padding(AppTheme.Spacing.xl)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView(appRouter: AppRouter())
}
