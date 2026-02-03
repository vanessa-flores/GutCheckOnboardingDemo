import Foundation
import SwiftUI
import Observation

// MARK: - SymptomCategorySelectable Protocol

protocol SymptomCategorySelectable: AnyObject, Observable {

    // MARK: - Required Properties

    var expandedCategories: Set<SymptomCategory> { get set }
    var selectedSymptomIds: Set<UUID> { get set }
    var symptomsByCategory: [(category: SymptomCategory, symptoms: [Symptom])] { get }
}

// MARK: - Default Implementations

extension SymptomCategorySelectable {

    func isCategoryExpanded(_ category: SymptomCategory) -> Bool {
        expandedCategories.contains(category)
    }

    func toggleCategory(_ category: SymptomCategory) {
        withAnimation(.easeInOut(duration: AppTheme.Animation.quick)) {
            if expandedCategories.contains(category) {
                expandedCategories.remove(category)
            } else {
                expandedCategories.insert(category)
            }
        }
    }

    func isSymptomSelected(_ id: UUID) -> Bool {
        selectedSymptomIds.contains(id)
    }

    func toggleSymptom(_ id: UUID) {
        if selectedSymptomIds.contains(id) {
            selectedSymptomIds.remove(id)
        } else {
            selectedSymptomIds.insert(id)
        }
    }

    var selectedSymptomCount: Int {
        selectedSymptomIds.count
    }
}
