import Foundation

protocol CheckInRepositoryProtocol: SymptomCatalogProtocol {
    func dailyLog(for userId: UUID, on: Date) -> DailyLog?
    func save(dailyLog: DailyLog)
}
