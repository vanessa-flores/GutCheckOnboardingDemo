import SwiftUI

// MARK: - Selectable Card

struct SelectableCard: View {
    
    // MARK: - Properties

    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.xl) {
                Text(text)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Checkmark circle
                ZStack {
                    Circle()
                        .strokeBorder(
                            isSelected ? Color.clear : AppTheme.Colors.textSecondary.opacity(0.3),
                            lineWidth: 2
                        )
                        .background(
                            Circle()
                                .fill(isSelected ? AppTheme.Colors.primaryAction : Color.clear)
                        )
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                isSelected
                    ? AppTheme.Colors.primaryAction.opacity(0.18)
                    : AppTheme.Colors.surface
            )
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        SelectableCard(
            text: "I want to understand what's happening in my body",
            isSelected: false,
            onTap: {}
        )

        SelectableCard(
            text: "I'm curious about the gut-hormone connection",
            isSelected: true,
            onTap: {}
        )

        SelectableCard(
            text: "I'm ready to discover what helps me feel better",
            isSelected: false,
            onTap: {}
        )
    }
    .padding(AppTheme.Spacing.xl)
    .background(AppTheme.Colors.background)
}
