import SwiftUI

// MARK: - Severity Picker

/// Horizontal pill selector for symptom severity levels.
/// Displays Mild/Moderate/Severe options with selection state.
struct SeverityPicker: View {

    // MARK: - Properties

    let currentSeverity: Severity?
    let onSelect: (Severity) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // Helper text
            Text("How severe? (optional)")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)

            // Severity pills
            HStack(spacing: 8) {
                ForEach(Severity.allCases, id: \.self) { severity in
                    SeverityPill(
                        severity: severity,
                        isSelected: currentSeverity == severity,
                        onTap: {
                            onSelect(severity)
                        }
                    )
                    .accessibilityLabel("\(severity.rawValue) severity")
                    .accessibilityHint(currentSeverity == severity ? "Currently selected" : "Double tap to select")
                }
            }
        }
    }
}

// MARK: - Severity Pill

/// Individual pill button for a severity option.
private struct SeverityPill: View {

    // MARK: - Properties

    let severity: Severity
    let isSelected: Bool
    let onTap: () -> Void

    // MARK: - State

    @State private var isPressed: Bool = false

    // MARK: - Body

    var body: some View {
        Button(action: handleTap) {
            Text(severity.rawValue)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    isSelected
                        ? AppTheme.Colors.primaryAction.opacity(0.1)
                        : Color.clear
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isSelected
                                ? AppTheme.Colors.primaryAction
                                : AppTheme.Colors.textSecondary.opacity(0.3),
                            lineWidth: isSelected ? 1.5 : 1
                        )
                )
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
    }

    // MARK: - Actions

    private func handleTap() {
        // Trigger press animation
        isPressed = true

        // Light haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        // Reset press state after brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed = false
        }

        // Call the selection handler
        onTap()
    }
}

// MARK: - Preview

#Preview("No Selection") {
    VStack(spacing: AppTheme.Spacing.xl) {
        SeverityPicker(
            currentSeverity: nil,
            onSelect: { severity in
                print("Selected: \(severity.rawValue)")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.surface)
}

#Preview("Mild Selected") {
    VStack(spacing: AppTheme.Spacing.xl) {
        SeverityPicker(
            currentSeverity: .mild,
            onSelect: { severity in
                print("Selected: \(severity.rawValue)")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.surface)
}

#Preview("Moderate Selected") {
    VStack(spacing: AppTheme.Spacing.xl) {
        SeverityPicker(
            currentSeverity: .moderate,
            onSelect: { severity in
                print("Selected: \(severity.rawValue)")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.surface)
}

#Preview("Severe Selected") {
    VStack(spacing: AppTheme.Spacing.xl) {
        SeverityPicker(
            currentSeverity: .severe,
            onSelect: { severity in
                print("Selected: \(severity.rawValue)")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.surface)
}
