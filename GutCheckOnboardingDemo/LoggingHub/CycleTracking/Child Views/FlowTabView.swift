import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

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
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(contentBackground)
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
