import Foundation

struct OnboardingSymptomCategory: Identifiable {
    let id: String
    let title: String
    let symptoms: [OnboardingSymptom]
    let displayOrder: Int
}
