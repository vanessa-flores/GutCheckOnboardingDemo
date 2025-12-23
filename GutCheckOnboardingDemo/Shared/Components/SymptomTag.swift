import SwiftUI

struct SymptomTag: View {

    // MARK: - Properties

    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.textPrimary)
                .lineLimit(1)
                .padding(.horizontal, AppTheme.Spacing.md)
                .frame(height: 44)
                .background(
                    isSelected
                        ? AppTheme.Colors.primaryAction
                        : AppTheme.Colors.surface
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                        .strokeBorder(
                            isSelected ? Color.clear : AppTheme.Colors.textSecondary.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(AppTheme.CornerRadius.xlarge)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
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
