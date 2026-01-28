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
class CycleLogViewModel {

    // MARK: - Properties
    
    let userId: UUID
    let date: Date
    private let onSave: (Bool, FlowLevel?, Set<UUID>) -> Void

    // MARK: - State
    
    var selectedTab: CycleLogTab = .flow
    var hadFlow: Bool?
    var selectedFlowLevel: FlowLevel?
    var selectedSymptomIds: Set<UUID>
    
    // MARK: - Dependencies
    
    private let repository: SymptomRepositoryProtocol
    
    // MARK: - Computed

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    // MARK: - Init

    init(
        userId: UUID,
        date: Date,
        initialFlow: FlowLevel?,
        initialSelectedSymptomIds: Set<UUID>,
        repository: SymptomRepositoryProtocol,
        onSave: @escaping (Bool, FlowLevel?, Set<UUID>) -> Void
    ) {
        self.userId = userId
        self.date = date
        self.repository = repository
        self.onSave = onSave

        // Initialize flow state based on initial flow
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

        // Initialize symptom state
        self.selectedSymptomIds = initialSelectedSymptomIds
    }

    func selectFlowPresence(_ hasFlow: Bool) {
        if hadFlow == hasFlow {
            // Tapping same option again - deselect
            hadFlow = nil
            selectedFlowLevel = nil
        } else {
            // Selecting different option
            if hasFlow {
                // User tapped "Yes"
                hadFlow = true
            } else {
                // User tapped "No" (period but no flow)
                hadFlow = false
                selectedFlowLevel = nil
            }
        }
    }

    func selectFlowLevel(_ level: FlowLevel) {
        if selectedFlowLevel == level {
            selectedFlowLevel = nil
        } else {
            selectedFlowLevel = level
            hadFlow = true
        }
    }

    func toggleSymptom(_ symptomId: UUID) {
        if selectedSymptomIds.contains(symptomId) {
            selectedSymptomIds.remove(symptomId)
        } else {
            selectedSymptomIds.insert(symptomId)
        }
    }

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
