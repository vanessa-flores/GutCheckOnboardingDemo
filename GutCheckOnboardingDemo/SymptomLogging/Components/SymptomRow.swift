import SwiftUI

// MARK: - Symptom Row

/// Individual symptom card with expand/collapse behavior.
/// Displays symptom name, logged state, and severity when applicable.
struct SymptomRow: View {

    // MARK: - Properties

    let symptom: Symptom
    let currentLog: SymptomLog?
    let isExpanded: Bool
    let onTap: () -> Void
    let onSelectSeverity: (Severity) -> Void
    let onRemove: () -> Void

    // MARK: - Computed Properties

    private var isLogged: Bool {
        currentLog != nil
    }

    private var severityText: String? {
        currentLog?.severity.rawValue
    }

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Main row content
                mainContent

                // Expanded content (severity picker + remove button)
                if isExpanded && isLogged {
                    expandedContent
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppTheme.Animation.standard), value: isExpanded)
    }

    // MARK: - Main Content

    private var mainContent: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            // Checkmark for logged state
            if isLogged {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.Colors.success)
            }

            // Symptom info
            VStack(alignment: .leading, spacing: 2) {
                // Symptom name with optional severity
                HStack(spacing: AppTheme.Spacing.xs) {
                    Text(symptom.name)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    // Show severity inline when collapsed and logged with severity
                    if !isExpanded, let severity = severityText {
                        Text("(\(severity))")
                            .font(AppTheme.Typography.bodyMedium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }

                // "Tap to log" hint for unlogged symptoms
                if !isLogged {
                    Text("Tap to log")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            Spacer()
        }
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Severity picker
            SeverityPicker(
                currentSeverity: currentLog?.severity,
                onSelect: onSelectSeverity
            )

            // Remove button
            removeButton
        }
        .padding(.top, AppTheme.Spacing.md)
    }

    // MARK: - Remove Button

    private var removeButton: some View {
        Button(action: onRemove) {
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))

                Text("Remove this symptom")
                    .font(AppTheme.Typography.caption)
            }
            .foregroundColor(AppTheme.Colors.error)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview("Unlogged") {
    VStack(spacing: AppTheme.Spacing.sm) {
        SymptomRow(
            symptom: Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 0),
            currentLog: nil,
            isExpanded: false,
            onTap: {},
            onSelectSeverity: { _ in },
            onRemove: {}
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Logged Collapsed") {
    VStack(spacing: AppTheme.Spacing.sm) {
        SymptomRow(
            symptom: Symptom(name: "Bloating", category: .digestiveGutHealth, displayOrder: 0),
            currentLog: SymptomLog(
                userId: UUID(),
                symptomId: UUID(),
                date: Date(),
                severity: .moderate
            ),
            isExpanded: false,
            onTap: {},
            onSelectSeverity: { _ in },
            onRemove: {}
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Logged Expanded") {
    VStack(spacing: AppTheme.Spacing.sm) {
        SymptomRow(
            symptom: Symptom(name: "Anxiety", category: .energyMoodMental, displayOrder: 0),
            currentLog: SymptomLog(
                userId: UUID(),
                symptomId: UUID(),
                date: Date(),
                severity: .moderate
            ),
            isExpanded: true,
            onTap: {},
            onSelectSeverity: { _ in },
            onRemove: {}
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}
