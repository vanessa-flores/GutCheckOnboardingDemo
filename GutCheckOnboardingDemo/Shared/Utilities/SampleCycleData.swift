import Foundation

// MARK: - Sample Cycle Data

/// Utility for loading realistic sample data for testing and development
struct SampleCycleData {

    // MARK: - Sample User

    /// Fixed sample user ID for consistency across app launches
    static let sampleUserId = UUID(uuidString: "12345678-1234-1234-1234-123456789012")!

    // MARK: - Loading

    /// Loads sample data if it doesn't already exist for the sample user
    /// - Parameter repository: Repository conforming to both DailyLogRepositoryProtocol and SymptomCatalogProtocol
    static func loadIfNeeded(into repository: any DailyLogRepositoryProtocol & SymptomCatalogProtocol) {
        // Check if data already exists for sample user
        let existingLogs = repository.dailyLogs(for: sampleUserId)
        if !existingLogs.isEmpty {
            return // Data already loaded, don't re-load
        }

        // Load the sample data
        loadSampleData(into: repository)
    }

    // MARK: - Private Loading Logic

    /// Loads realistic cycle and symptom data for the sample user
    private static func loadSampleData(into repository: any DailyLogRepositoryProtocol & SymptomCatalogProtocol) {
        let today = Date().startOfDay

        // Find symptom IDs by name from repository
        let bloatingId = repository.allSymptoms.first { $0.name == "Bloating" }?.id
        let breastSorenessId = repository.allSymptoms.first { $0.name == "Breast soreness" }?.id
        let moodSwingsId = repository.allSymptoms.first { $0.name == "Mood swings" }?.id
        let headachesId = repository.allSymptoms.first { $0.name == "Headaches" }?.id
        let fatigueId = repository.allSymptoms.first { $0.name == "Fatigue" }?.id

        // Define 5 cycles working backward from today
        // Each cycle starts on period day 1
        // Cycle lengths are measured from period start to next period start
        //
        // Cycle 5 (ongoing): Started 47 days ago, currently on day 47
        // Cycle 4: Started 88 days ago (47 + 41), 41-day cycle, 4 flow days
        // Cycle 3: Started 140 days ago (88 + 52), 52-day cycle, 3 flow days
        // Cycle 2: Started 179 days ago (140 + 39), 39-day cycle, 4 flow days
        // Cycle 1: Started 216 days ago (179 + 37), 37-day cycle, 5 flow days

        // Define cycles with realistic perimenopause patterns:
        // - Varying cycle lengths (37-52 days)
        // - Consistent symptom patterns before each period
        // - Last cycle is ongoing (no end date)
        let cycleConfigs: [CycleConfig] = [
            CycleConfig(
                startDaysAgo: 216,
                cycleLength: 37,
                flowDays: 5,
                symptoms: [
                    .bloating: [2, 3],           // 2-3 days before
                    .breastSoreness: [1, 2],     // 1-2 days before
                    .moodSwings: [3, 4],         // 3-4 days before
                    .fatigue: [2, 3, 4]          // 2-4 days before
                ]
            ),
            CycleConfig(
                startDaysAgo: 179,
                cycleLength: 39,
                flowDays: 4,
                symptoms: [
                    .bloating: [2, 3],
                    .breastSoreness: [1, 2],
                    .headaches: [1],             // 1 day before
                    .fatigue: [2, 3, 4]
                ]
            ),
            CycleConfig(
                startDaysAgo: 140,
                cycleLength: 52,
                flowDays: 3,
                symptoms: [
                    .bloating: [2, 3],
                    .breastSoreness: [1, 2],
                    .moodSwings: [3, 4]
                ]
            ),
            CycleConfig(
                startDaysAgo: 88,
                cycleLength: 41,
                flowDays: 4,
                symptoms: [
                    .bloating: [2, 3],
                    .breastSoreness: [1, 2],
                    .moodSwings: [3, 4],
                    .headaches: [1],
                    .fatigue: [2, 3, 4]
                ]
            ),
            CycleConfig(
                startDaysAgo: 47,
                cycleLength: 0,  // Ongoing - no end yet
                flowDays: 4,     // Period started 47 days ago (marks cycle beginning)
                symptoms: [
                    .bloating: [2, 3],
                    .breastSoreness: [1, 2],
                    .moodSwings: [3, 4],
                    .fatigue: [2, 3, 4]
                ]
            )
        ]

        // Load each cycle
        for config in cycleConfigs {
            loadCycle(
                config: config,
                today: today,
                into: repository,
                symptomIds: SymptomIds(
                    bloating: bloatingId,
                    breastSoreness: breastSorenessId,
                    moodSwings: moodSwingsId,
                    headaches: headachesId,
                    fatigue: fatigueId
                )
            )
        }
    }

    /// Loads a single cycle with flow data and pre-period symptoms
    private static func loadCycle(
        config: CycleConfig,
        today: Date,
        into repository: any DailyLogRepositoryProtocol & SymptomCatalogProtocol,
        symptomIds: SymptomIds
    ) {
        let cycleStartDate = today.addingDays(-config.startDaysAgo)

        // Add flow days if this is a completed cycle with period data
        if config.flowDays > 0 {
            for dayOffset in 0..<config.flowDays {
                let flowDate = cycleStartDate.addingDays(dayOffset)

                // Vary flow levels: heavy at start, lighter toward end
                let flowLevel: FlowLevel = {
                    switch dayOffset {
                    case 0: return .heavy
                    case 1: return .heavy
                    case 2: return .medium
                    case 3: return .light
                    default: return .light
                    }
                }()

                let dailyLog = DailyLog(
                    userId: sampleUserId,
                    date: flowDate,
                    flowLevel: flowLevel,
                    hadSpotting: false,
                    symptomLogs: []
                )
                repository.save(dailyLog: dailyLog)
            }
        }

        // Add pre-period symptoms (1-5 days before period start)
        for (symptomType, daysBefore) in config.symptoms {
            guard let symptomId = symptomIds.id(for: symptomType) else { continue }

            for dayBefore in daysBefore {
                addSymptom(
                    symptomId: symptomId,
                    daysBeforePeriod: dayBefore,
                    periodStartDate: cycleStartDate,
                    into: repository
                )
            }
        }
    }

    /// Adds a symptom log N days before a period start date
    private static func addSymptom(
        symptomId: UUID,
        daysBeforePeriod: Int,
        periodStartDate: Date,
        into repository: any DailyLogRepositoryProtocol & SymptomCatalogProtocol
    ) {
        let symptomDate = periodStartDate.addingDays(-daysBeforePeriod)

        let symptomLog = SymptomLog(
            userId: sampleUserId,
            symptomId: symptomId,
            date: symptomDate,
            severity: .moderate
        )

        // Get or create daily log for this date
        var dailyLog = repository.dailyLog(for: sampleUserId, on: symptomDate) ?? DailyLog(
            userId: sampleUserId,
            date: symptomDate
        )

        // Add symptom to daily log
        dailyLog = dailyLog.addingSymptomLog(symptomLog)
        repository.save(dailyLog: dailyLog)
    }
}

// MARK: - Supporting Types

/// Configuration for a single cycle
private struct CycleConfig {
    let startDaysAgo: Int
    let cycleLength: Int
    let flowDays: Int
    let symptoms: [SymptomType: [Int]]  // symptomType -> days before period
}

/// Symptom types tracked in demo data
private enum SymptomType {
    case bloating
    case breastSoreness
    case moodSwings
    case headaches
    case fatigue
}

/// Container for symptom IDs
private struct SymptomIds {
    let bloating: UUID?
    let breastSoreness: UUID?
    let moodSwings: UUID?
    let headaches: UUID?
    let fatigue: UUID?

    func id(for type: SymptomType) -> UUID? {
        switch type {
        case .bloating: return bloating
        case .breastSoreness: return breastSoreness
        case .moodSwings: return moodSwings
        case .headaches: return headaches
        case .fatigue: return fatigue
        }
    }
}
