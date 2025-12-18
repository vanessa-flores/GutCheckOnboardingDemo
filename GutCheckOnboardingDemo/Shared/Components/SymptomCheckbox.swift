import SwiftUI

/// Checkbox component for symptom selection in onboarding
// TODO: - Remove if not used in Getting Started flow
struct SymptomCheckbox: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.ComponentSizes.checkboxCornerRadius)
                        .stroke(AppTheme.Colors.textSecondary, lineWidth: 2)
                        .frame(width: AppTheme.ComponentSizes.checkboxSize, height: AppTheme.ComponentSizes.checkboxSize)

                    if isSelected {
                        RoundedRectangle(cornerRadius: AppTheme.ComponentSizes.checkboxCornerRadius)
                            .fill(AppTheme.Colors.primaryAction)
                            .frame(width: AppTheme.ComponentSizes.checkboxSize, height: AppTheme.ComponentSizes.checkboxSize)

                        Image(systemName: "checkmark")
                            .font(.system(size: AppTheme.ComponentSizes.checkmarkIconSize, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }

                Text(label)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()
            }
            .padding(.vertical, AppTheme.Spacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.textSecondary.opacity(0.1))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    VStack {
        SymptomCheckbox(label: "Sample symptom", isSelected: false) {}
        SymptomCheckbox(label: "Selected symptom", isSelected: true) {}
    }
    .padding()
}
