import Foundation

// MARK: - Symptom

struct Symptom: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let category: SymptomCategory
    let displayOrder: Int
    let isEventBased: Bool

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        category: SymptomCategory,
        displayOrder: Int,
        isEventBased: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.displayOrder = displayOrder
        self.isEventBased = isEventBased
    }
}

// MARK: - Symptom Extensions

extension Symptom {
    var displayText: String {
        name
    }
}

// MARK: - Symptom Sorting

extension Array where Element == Symptom {
    /// Returns symptoms sorted by category display order, then by symptom display order within category
    func sortedForDisplay() -> [Symptom] {
        sorted { lhs, rhs in
            if lhs.category.displayOrder != rhs.category.displayOrder {
                return lhs.category.displayOrder < rhs.category.displayOrder
            }
            return lhs.displayOrder < rhs.displayOrder
        }
    }

    /// Returns symptoms grouped by category, maintaining display order
    func groupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])] {
        let grouped = Dictionary(grouping: self) { $0.category }
        return SymptomCategory.allCases.compactMap { category in
            guard let symptoms = grouped[category], !symptoms.isEmpty else { return nil }
            return (category: category, symptoms: symptoms.sorted { $0.displayOrder < $1.displayOrder })
        }
    }
}
