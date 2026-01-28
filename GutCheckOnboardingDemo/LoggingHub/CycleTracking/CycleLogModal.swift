import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct CycleLogModal: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CycleLogViewModel

    init(
        userId: UUID,
        date: Date,
        initialFlow: FlowLevel?,
        initialSelectedSymptomIds: Set<UUID>,
        repository: SymptomRepositoryProtocol,
        onSave: @escaping (Bool, FlowLevel?, Set<UUID>) -> Void
    ) {
        self._viewModel = State(initialValue: CycleLogViewModel(
            userId: userId,
            date: date,
            initialFlow: initialFlow,
            initialSelectedSymptomIds: initialSelectedSymptomIds,
            repository: repository,
            onSave: onSave
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Tab", selection: $viewModel.selectedTab) {
                    Text("Flow").tag(CycleLogTab.flow)
                    Text("Symptoms").tag(CycleLogTab.symptoms)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, AppTheme.Spacing.sm)

                Text(viewModel.formattedDate)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, AppTheme.Spacing.sm)
                    .padding(.bottom, AppTheme.Spacing.sm)

                ZStack {
                    contentBackground
                        .ignoresSafeArea()

                    tabContent
                }
            }
            .background(Color.white)
            .navigationTitle("Log Period")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.save()
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch viewModel.selectedTab {
        case .flow:
            FlowTabView(
                displayData: viewModel.flowTabDisplayData,
                onFlowPresenceSelected: { optionId in
                    viewModel.selectFlowPresence(optionId)
                },
                onFlowLevelSelected: { optionId in
                    viewModel.selectFlowLevel(optionId)
                }
            )
        case .symptoms:
            CycleSymptomsTabView(
                displayData: viewModel.symptomsTabDisplayData,
                onSymptomToggled: { symptomId in
                    viewModel.toggleSymptom(symptomId)
                }
            )
        }
    }
}

// MARK: - Preview

#Preview {
    let repository = InMemorySymptomRepository.shared

    let bloating = repository.allSymptoms.first { $0.name == "Bloating" }
    let fatigue = repository.allSymptoms.first { $0.name == "Fatigue" }
    let initialSymptomIds = Set([bloating?.id, fatigue?.id].compactMap { $0 })

    return CycleLogModal(
        userId: UUID(),
        date: Date(),
        initialFlow: .medium,
        initialSelectedSymptomIds: initialSymptomIds,
        repository: repository,
        onSave: { isTracking, flow, symptomIds in
            print("Tracking: \(isTracking), Flow: \(String(describing: flow)), Symptoms: \(symptomIds.count)")
        }
    )
}
