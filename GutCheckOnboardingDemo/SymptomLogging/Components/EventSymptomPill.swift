import SwiftUI

struct EventSymptomPill: View {

    // MARK: - Properties

    let symptom: Symptom
    let onTap: () -> Void

    @State private var isAnimating: Bool = false
    @State private var scale: CGFloat = 1.0

    // MARK: - Body

    var body: some View {
        Button(action: handleTap) {
            HStack(spacing: 4) {
                Text(symptom.name)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(isAnimating ? .white : AppTheme.Colors.textPrimary)
                    .lineLimit(1)

                if isAnimating {
                    Image(systemName: "checkmark")
                        .font(AppTheme.Typography.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .frame(height: 44)
            .background(
                isAnimating
                    ? AppTheme.Colors.primaryAction
                    : AppTheme.Colors.surface
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                    .strokeBorder(
                        isAnimating ? Color.clear : AppTheme.Colors.textSecondary.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
            .cornerRadius(AppTheme.CornerRadius.xlarge)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .scaleEffect(scale)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isAnimating)
    }

    // MARK: - Actions

    private func handleTap() {
        // Trigger haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        // Animate to selected state with spring animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isAnimating = true
            scale = 1.05
        }

        // Log the symptom
        onTap()

        // Return to default state after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = false
                scale = 1.0
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("Tap a pill to see the animation")
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.textSecondary)

        HStack(spacing: 8) {
            EventSymptomPill(
                symptom: Symptom(name: "Hot flashes", category: .sleepTemperature, displayOrder: 0, isEventBased: true),
                onTap: { print("Logged: Hot flashes") }
            )

            EventSymptomPill(
                symptom: Symptom(name: "Anxiety", category: .energyMoodMental, displayOrder: 0, isEventBased: true),
                onTap: { print("Logged: Anxiety") }
            )
        }

        HStack(spacing: 8) {
            EventSymptomPill(
                symptom: Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 0, isEventBased: true),
                onTap: { print("Logged: Bloating") }
            )

            EventSymptomPill(
                symptom: Symptom(name: "Headaches", category: .physicalPain, displayOrder: 0, isEventBased: true),
                onTap: { print("Logged: Headaches") }
            )
        }
    }
    .padding(AppTheme.Spacing.xl)
    .background(AppTheme.Colors.background)
}
