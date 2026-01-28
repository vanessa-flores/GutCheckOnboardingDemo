import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct CycleLogModal: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CycleLogViewModel
    private let repository: SymptomRepositoryProtocol

    init(
        userId: UUID,
        date: Date,
        initialFlow: FlowLevel?,
        initialSelectedSymptomIds: Set<UUID>,
        repository: SymptomRepositoryProtocol,
        onSave: @escaping (Bool, FlowLevel?, Set<UUID>) -> Void
    ) {
        self.repository = repository
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

                    switch viewModel.selectedTab {
                    case .flow:
                        FlowTabView(
                            hadFlow: $viewModel.hadFlow,
                            selectedFlowLevel: $viewModel.selectedFlowLevel
                        )
                    case .symptoms:
                        CycleSymptomsTabView(
                            selectedSymptomIds: $viewModel.selectedSymptomIds,
                            repository: repository
                        )
                    }
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
