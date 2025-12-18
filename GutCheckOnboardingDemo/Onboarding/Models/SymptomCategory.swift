import Foundation

struct SymptomCategory: Identifiable {
    let id: String
    let title: String
    let symptoms: [Symptom]
    let displayOrder: Int
}
