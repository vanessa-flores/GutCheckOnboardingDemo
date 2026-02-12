import SwiftUI
import Observation

// MARK: - CycleLogTab

enum CycleLogTab: String, CaseIterable, Identifiable {
    case flow = "Flow"
    case symptoms = "Symptoms"

    var id: String { rawValue }
}

// MARK: - CycleLogViewModel

@Observable
class CycleLogViewModel: SymptomCategorySelectable {

    // MARK: - Dependencies

    private let repository: SymptomCatalogProtocol
    private let onSave: (Bool, FlowLevel?, Set<UUID>) -> Void

    // MARK: - Properties

    let userId: UUID
    let date: Date

    // MARK: - Tab State

    var selectedTab: CycleLogTab = .flow

    // MARK: - Flow State (private)

    private(set) var hadFlow: Bool?
    private(set) var selectedFlowLevel: FlowLevel?

    // MARK: - SymptomCategorySelectable Properties

    var selectedSymptomIds: Set<UUID>
    var expandedCategories: Set<SymptomCategory> = [
        .cycleHormonal,
        .digestiveGutHealth,
        .energyMoodMental
    ]

    // MARK: - Computed

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    var symptomsByCategory: [(category: SymptomCategory, symptoms: [Symptom])] {
        SymptomFilteringService.cycleTrackingSymptoms(from: repository)
    }

    var symptomSelectionCountText: String {
        let count = selectedSymptomIds.count
        return "\(count) symptom\(count == 1 ? "" : "s") selected"
    }

    // MARK: - Init

    init(
        userId: UUID,
        date: Date,
        initialFlow: FlowLevel?,
        initialSelectedSymptomIds: Set<UUID>,
        repository: SymptomCatalogProtocol,
        onSave: @escaping (Bool, FlowLevel?, Set<UUID>) -> Void
    ) {
        self.userId = userId
        self.date = date
        self.repository = repository
        self.onSave = onSave

        if let initialFlow = initialFlow {
            if initialFlow == .none {
                // Was tracking period with no flow
                self.hadFlow = false
                self.selectedFlowLevel = nil
            } else {
                // Was tracking period with flow
                self.hadFlow = true
                self.selectedFlowLevel = initialFlow
            }
        } else {
            // Not tracking period
            self.hadFlow = nil
            self.selectedFlowLevel = nil
        }

        self.selectedSymptomIds = initialSelectedSymptomIds
    }

    // MARK: - Flow Tab Display Data

    var flowTabDisplayData: FlowTabDisplayData {
        FlowTabDisplayData(
            flowPresenceOptions: [
                SelectableOption(id: "yes", title: "Yes", isSelected: hadFlow == true),
                SelectableOption(id: "no", title: "No", isSelected: hadFlow == false)
            ],
            flowLevelOptions: [
                SelectableOption(id: FlowLevel.light.rawValue, title: FlowLevel.light.description, isSelected: selectedFlowLevel == .light),
                SelectableOption(id: FlowLevel.medium.rawValue, title: FlowLevel.medium.description, isSelected: selectedFlowLevel == .medium),
                SelectableOption(id: FlowLevel.heavy.rawValue, title: FlowLevel.heavy.description, isSelected: selectedFlowLevel == .heavy)
            ]
        )
    }

    // MARK: - Flow Tab Actions

    func selectFlowPresence(_ optionId: String) {
        let isYes = optionId == "yes"

        if hadFlow == isYes {
            // Tapping same option again - deselect
            hadFlow = nil
            selectedFlowLevel = nil
        } else {
            // Selecting different option
            if isYes {
                // User tapped "Yes"
                hadFlow = true
            } else {
                // User tapped "No" (period but no flow)
                hadFlow = false
                selectedFlowLevel = nil
            }
        }
    }

    func selectFlowLevel(_ optionId: String) {
        let level = FlowLevel(rawValue: optionId)

        if selectedFlowLevel == level {
            selectedFlowLevel = nil
        } else {
            selectedFlowLevel = level
            hadFlow = true
        }
    }

    // MARK: - Save

    func save() {
        if hadFlow == true {
            // "Yes" selected - save with flow level if specified, otherwise .none
            let flowLevel = selectedFlowLevel ?? .none
            onSave(true, flowLevel, selectedSymptomIds)
        } else if hadFlow == false {
            // "No" selected (period but no flow)
            onSave(true, FlowLevel.none, selectedSymptomIds)
        } else {
            // Nothing selected - don't save flow tracking
            onSave(false, nil, selectedSymptomIds)
        }
    }
}
