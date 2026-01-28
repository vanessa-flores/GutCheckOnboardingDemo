import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct FlowTabView: View {
    @Binding var hadFlow: Bool?
    @Binding var selectedFlowLevel: FlowLevel?

    var body: some View {
        List {
            Section("Did you have flow today?") {
                SelectableRow(
                    title: "Yes",
                    isSelected: hadFlow == true,
                    action: { handleFlowPresenceSelection(true) }
                )

                SelectableRow(
                    title: "No",
                    isSelected: hadFlow == false,
                    action: { handleFlowPresenceSelection(false) }
                )
            }

            Section("Flow Level") {
                ForEach([FlowLevel.light, .medium, .heavy], id: \.self) { level in
                    SelectableRow(
                        title: level.rawValue,
                        isSelected: selectedFlowLevel == level,
                        action: { handleFlowLevelSelection(level) }
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(contentBackground)
    }

    // MARK: - Helper Methods

    private func handleFlowPresenceSelection(_ hasFlow: Bool) {
        if hadFlow == hasFlow {
            hadFlow = nil
            selectedFlowLevel = nil
        } else {
            if hasFlow {
                hadFlow = true
            } else {
                hadFlow = false
                selectedFlowLevel = nil
            }
        }
    }

    private func handleFlowLevelSelection(_ level: FlowLevel) {
        if selectedFlowLevel == level {
            selectedFlowLevel = nil
        } else {
            selectedFlowLevel = level
            hadFlow = true
        }
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var hadFlow: Bool? = nil
        @State private var selectedFlowLevel: FlowLevel? = nil

        var body: some View {
            FlowTabView(
                hadFlow: $hadFlow,
                selectedFlowLevel: $selectedFlowLevel
            )
        }
    }

    return PreviewWrapper()
}
