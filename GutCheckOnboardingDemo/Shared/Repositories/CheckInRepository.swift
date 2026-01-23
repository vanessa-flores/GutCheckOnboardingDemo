import Foundation

protocol CheckInRepository {
    func getTodaysLog(for userId: UUID) -> DailyLog?
    func save(dailyLog: DailyLog)
    func symptomsGroupedByCategory() -> [(category: SymptomCategory, symptoms: [Symptom])]
}
