import SwiftUI

struct SymptomTag: View {

    // MARK: - Properties

    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.caption)
            .foregroundStyle(isSelected ? AppTheme.Colors.textOnPrimary : AppTheme.Colors.textPrimary)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.xlarge)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                    .stroke(
                        isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
            .onTapGesture {
                onTap()
            }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 8) {
            SymptomTag(text: "Bloating", isSelected: false, onTap: {})
            SymptomTag(text: "Anxiety", isSelected: true, onTap: {})
            SymptomTag(text: "Hot flashes", isSelected: false, onTap: {})
        }

        HStack(spacing: 8) {
            SymptomTag(text: "Brain fog", isSelected: true, onTap: {})
            SymptomTag(text: "Fatigue", isSelected: false, onTap: {})
        }
    }
    .padding(AppTheme.Spacing.xl)
    .background(AppTheme.Colors.background)
}
