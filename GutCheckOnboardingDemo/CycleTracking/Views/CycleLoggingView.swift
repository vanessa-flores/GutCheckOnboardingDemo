import SwiftUI

struct CycleLoggingView: View {

    @Bindable var viewModel: CycleLoggingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Log")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.bottom, AppTheme.Spacing.md)

            VStack(spacing: 0) {
                PeriodRow(viewModel: viewModel)

                Divider()
                    .background(AppTheme.Colors.background)

                SymptomsRow(viewModel: viewModel)

                Divider()
                    .background(AppTheme.Colors.background)

                SpottingRow(viewModel: viewModel)
            }
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

// MARK: - Period Row

private struct PeriodRow: View {

    @Bindable var viewModel: CycleLoggingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Button(action: handleRowTap) {
                HStack {
                    Text("Period")
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

                    periodStatus
                }
                .padding(AppTheme.Spacing.lg)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.isFutureDate)
            .opacity(viewModel.isFutureDate ? 0.4 : 1.0)

            if viewModel.isPeriodExpanded {
                flowLevelPicker
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(AppTheme.Colors.surface)
    }

    @ViewBuilder
    private var periodStatus: some View {
        if !viewModel.isPeriodLogged {
            Button(action: handleCircleTap) {
                Circle()
                    .strokeBorder(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
        } else if let flow = viewModel.selectedFlowLevel {
            Text(flow.rawValue)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.primaryAction)
        } else {
            Button(action: handleCircleTap) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primaryAction)
                        .frame(width: 24, height: 24)

                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var flowLevelPicker: some View {
        HStack(spacing: 8) {
            ForEach(FlowLevel.allCases, id: \.self) { level in
                FlowLevelPill(
                    level: level,
                    isSelected: viewModel.selectedFlowLevel == level,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectFlowLevel(level)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.lg)
    }

    private func handleRowTap() {
        withAnimation(.easeInOut(duration: AppTheme.Animation.standard)) {
            viewModel.togglePeriodExpanded()
        }
    }

    private func handleCircleTap() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.togglePeriodLogged()
        }
    }
}

// MARK: - Flow Level Pill

private struct FlowLevelPill: View {

    let level: FlowLevel
    let isSelected: Bool
    let onTap: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: handleTap) {
            Text(level.rawValue)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(isSelected ? AppTheme.Colors.primaryAction : AppTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, AppTheme.Spacing.md)
                .background(
                    isSelected
                        ? AppTheme.Colors.primaryAction.opacity(0.1)
                        : Color.clear
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                        .stroke(
                            isSelected
                                ? AppTheme.Colors.primaryAction
                                : AppTheme.Colors.textSecondary.opacity(0.3),
                            lineWidth: isSelected ? 1.5 : 1
                        )
                )
                .cornerRadius(AppTheme.CornerRadius.xlarge)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }

    private func handleTap() {
        isPressed = true

        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed = false
        }

        onTap()
    }
}

// MARK: - Symptoms Row

private struct SymptomsRow: View {

    @Bindable var viewModel: CycleLoggingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Button(action: handleRowTap) {
                HStack {
                    Text("Symptoms")
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

                    symptomsStatus
                }
                .padding(AppTheme.Spacing.lg)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.isFutureDate)
            .opacity(viewModel.isFutureDate ? 0.4 : 1.0)

            if viewModel.areSymptomsExpanded {
                symptomsList
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(AppTheme.Colors.surface)
    }

    @ViewBuilder
    private var symptomsStatus: some View {
        if !viewModel.areSymptomsLogged || viewModel.selectedSymptomIds.isEmpty {
            Button(action: handleCircleTap) {
                Circle()
                    .strokeBorder(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Text(viewModel.symptomSummaryText)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(AppTheme.Colors.primaryAction)
        }
    }

    private var symptomsList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.periodSymptoms) { symptom in
                SymptomItemView(
                    symptom: symptom,
                    isSelected: viewModel.selectedSymptomIds.contains(symptom.id),
                    isExpanded: viewModel.expandedSeveritySymptomId == symptom.id,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.toggleSymptomSelection(symptom.id)
                        }
                    },
                    onSeveritySelect: { severity in
                        viewModel.updateSymptomSeverity(symptom.id, severity: severity)
                    }
                )

                if symptom.id != viewModel.periodSymptoms.last?.id {
                    Divider()
                        .background(AppTheme.Colors.background)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.lg)
    }

    private func handleRowTap() {
        withAnimation(.easeInOut(duration: AppTheme.Animation.standard)) {
            viewModel.toggleSymptomsExpanded()
        }
    }

    private func handleCircleTap() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.toggleSymptomsLogged()
        }
    }
}

// MARK: - Symptom Item View

private struct SymptomItemView: View {

    let symptom: Symptom
    let isSelected: Bool
    let isExpanded: Bool
    let onTap: () -> Void
    let onSeveritySelect: (Severity) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                onTap()
            }) {
                HStack {
                    Text(symptom.name)
                        .font(AppTheme.Typography.bodyMedium)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

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
                .padding(.vertical, AppTheme.Spacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                SeverityPicker(
                    currentSeverity: nil,  // TODO: Track selected severity per symptom in future iteration
                    onSelect: { severity in
                        onSeveritySelect(severity)
                    }
                )
                .padding(.top, AppTheme.Spacing.sm)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Spotting Row

private struct SpottingRow: View {

    @Bindable var viewModel: CycleLoggingViewModel

    var body: some View {
        Button(action: handleTap) {
            HStack {
                Text("Spotting")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                spottingStatus
            }
            .padding(AppTheme.Spacing.lg)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(viewModel.isFutureDate)
        .opacity(viewModel.isFutureDate ? 0.4 : 1.0)
        .background(AppTheme.Colors.surface)
    }

    @ViewBuilder
    private var spottingStatus: some View {
        if !viewModel.isSpottingLogged {
            Circle()
                .strokeBorder(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 2)
                .frame(width: 24, height: 24)
        } else {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryAction)
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }

    private func handleTap() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.toggleSpotting()
        }
    }
}

// MARK: - Preview

#Preview {
    let repo = InMemorySymptomRepository.shared
    let viewModel = CycleLoggingViewModel(
        userId: UUID(),
        selectedDate: Date(),
        repository: repo
    )

    CycleLoggingView(viewModel: viewModel)
        .background(AppTheme.Colors.background)
}
