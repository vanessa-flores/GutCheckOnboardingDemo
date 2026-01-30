import SwiftUI

// MARK: - FlowTabView

struct FlowTabView: View {
    let displayData: FlowTabDisplayData
    let onFlowPresenceSelected: (String) -> Void
    let onFlowLevelSelected: (String) -> Void

    var body: some View {
        List {
            Section {
                ForEach(displayData.flowPresenceOptions) { option in
                    SelectableRow(
                        title: option.title,
                        isSelected: option.isSelected
                    ) {
                        onFlowPresenceSelected(option.id)
                    }
                }
            } header: {
                Text("Did you have flow today?")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }

            Section {
                ForEach(displayData.flowLevelOptions) { option in
                    SelectableRow(
                        title: option.title,
                        isSelected: option.isSelected
                    ) {
                        onFlowLevelSelected(option.id)
                    }
                }
            } header: {
                Text("Flow Level")
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.surface)
    }
}

// MARK: - Preview

#Preview {
    FlowTabView(
        displayData: FlowTabDisplayData(
            flowPresenceOptions: [
                SelectableOption(id: "yes", title: "Yes", isSelected: true),
                SelectableOption(id: "no", title: "No", isSelected: false)
            ],
            flowLevelOptions: [
                SelectableOption(id: "light", title: "Light", isSelected: false),
                SelectableOption(id: "medium", title: "Medium", isSelected: true),
                SelectableOption(id: "heavy", title: "Heavy", isSelected: false)
            ]
        ),
        onFlowPresenceSelected: { id in print("Presence: \(id)") },
        onFlowLevelSelected: { id in print("Level: \(id)") }
    )
}
