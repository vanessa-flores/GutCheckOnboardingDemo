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
            HStack {
                Text("Period")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                Button(action: handleCircleTap) {
                    periodStatus
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(AppTheme.Spacing.lg)
            .disabled(viewModel.isFutureDate)
            .opacity(viewModel.isFutureDate ? 0.4 : 1.0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(FlowLevel.allCases, id: \.self) { level in
                        FlowLevelPill(
                            level: level,
                            isSelected: viewModel.selectedFlowLevel == level,
                            isDisabled: viewModel.isFutureDate,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.selectFlowLevel(level)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            .padding(.bottom, AppTheme.Spacing.lg)
            .disabled(viewModel.isFutureDate)
            .opacity(viewModel.isFutureDate ? 0.4 : 1.0)
        }
        .background(AppTheme.Colors.surface)
    }

    @ViewBuilder
    private var periodStatus: some View {
        if viewModel.isPeriodLogged {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryAction)
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        } else {
            Circle()
                .strokeBorder(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 2)
                .frame(width: 24, height: 24)
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
    let isDisabled: Bool
    let onTap: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: handleTap) {
            Text(level.rawValue)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(
                    isDisabled
                        ? AppTheme.Colors.textSecondary.opacity(0.3)
                        : (isSelected ? .white : AppTheme.Colors.textPrimary)
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, AppTheme.Spacing.md)
                .background(
                    isDisabled
                        ? Color.clear
                        : (isSelected
                            ? AppTheme.Colors.primaryAction
                            : AppTheme.Colors.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                        .strokeBorder(
                            isDisabled
                                ? AppTheme.Colors.textSecondary.opacity(0.2)
                                : (isSelected
                                    ? Color.clear
                                    : AppTheme.Colors.textSecondary.opacity(0.3)),
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(AppTheme.CornerRadius.xlarge)
                .shadow(
                    color: isDisabled ? Color.clear : Color.black.opacity(0.05),
                    radius: 2,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .disabled(isDisabled)
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
            Text("Symptoms")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppTheme.Spacing.lg)
                .disabled(viewModel.isFutureDate)
                .opacity(viewModel.isFutureDate ? 0.4 : 1.0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.periodSymptoms) { symptom in
                        SymptomPill(
                            symptom: symptom,
                            isSelected: viewModel.selectedSymptomIds.contains(symptom.id),
                            isDisabled: viewModel.isFutureDate,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.toggleSymptomSelection(symptom.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            .padding(.bottom, AppTheme.Spacing.lg)
            .disabled(viewModel.isFutureDate)
            .opacity(viewModel.isFutureDate ? 0.4 : 1.0)
        }
        .background(AppTheme.Colors.surface)
    }
}

// MARK: - Symptom Pill

private struct SymptomPill: View {

    let symptom: Symptom
    let isSelected: Bool
    let isDisabled: Bool
    let onTap: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: handleTap) {
            Text(symptom.name)
                .font(AppTheme.Typography.bodySmall)
                .foregroundColor(
                    isDisabled
                        ? AppTheme.Colors.textSecondary.opacity(0.3)
                        : (isSelected ? .white : AppTheme.Colors.textPrimary)
                )
                .padding(.vertical, 12)
                .padding(.horizontal, AppTheme.Spacing.md)
                .background(
                    isDisabled
                        ? Color.clear
                        : (isSelected
                            ? AppTheme.Colors.primaryAction
                            : AppTheme.Colors.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                        .strokeBorder(
                            isDisabled
                                ? AppTheme.Colors.textSecondary.opacity(0.2)
                                : (isSelected
                                    ? Color.clear
                                    : AppTheme.Colors.textSecondary.opacity(0.3)),
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(AppTheme.CornerRadius.xlarge)
                .shadow(
                    color: isDisabled ? Color.clear : Color.black.opacity(0.05),
                    radius: 2,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .disabled(isDisabled)
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

// MARK: - Spotting Row

private struct SpottingRow: View {

    @Bindable var viewModel: CycleLoggingViewModel

    var body: some View {
        HStack {
            Text("Spotting")
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Spacer()

            Button(action: handleTap) {
                spottingStatus
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.surface)
        .disabled(viewModel.isFutureDate)
        .opacity(viewModel.isFutureDate ? 0.4 : 1.0)
    }

    @ViewBuilder
    private var spottingStatus: some View {
        if viewModel.isSpottingLogged {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryAction)
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        } else {
            Circle()
                .strokeBorder(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 2)
                .frame(width: 24, height: 24)
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
