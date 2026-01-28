import Foundation

protocol CheckInRepository {
    func dailyLog(for userId: UUID, on: Date) -> DailyLog?
    func save(dailyLog: DailyLog)
    func symptomsGroupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])]
}
