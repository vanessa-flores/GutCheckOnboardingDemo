import SwiftUI

struct BehaviorsTabView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer()
            
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.3))
            
            Text("Behaviors tracking")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("Coming soon")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.surface)
    }
}

#Preview {
    BehaviorsTabView()
}
