import SwiftUI
import Observation

@Observable
class CycleLoggingViewModel {

    // MARK: - Dependencies

    private let userId: UUID
    private let repository: SymptomRepositoryProtocol & DailyLogRepositoryProtocol

    // MARK: - Input

    var selectedDate: Date {
        didSet {
            loadDataForSelectedDate()
        }
    }

    // MARK: - State

    var dailyLog: DailyLog?

    // Period state
    var isPeriodLogged: Bool = false
    var selectedFlowLevel: FlowLevel?
    var isPeriodExpanded: Bool = false

    // Symptoms state
    var areSymptomsLogged: Bool = false
    var selectedSymptomIds: Set<UUID> = []
    var areSymptomsExpanded: Bool = false
    var expandedSeveritySymptomId: UUID?

    // Spotting state
    var isSpottingLogged: Bool = false

    var periodSymptoms: [Symptom] = []

    // MARK: - Computed Properties

    var isFutureDate: Bool {
        selectedDate > Date().startOfDay
    }

    var symptomSummaryText: String {
        guard !selectedSymptomIds.isEmpty else { return "" }

        let selectedNames = periodSymptoms
            .filter { selectedSymptomIds.contains($0.id) }
            .map { $0.name }

        if selectedNames.count == 1 {
            return selectedNames[0]
        } else if selectedNames.count == 2 {
            return "\(selectedNames[0]), \(selectedNames[1])"
        } else {
            return "\(selectedNames[0]), \(selectedNames.count - 1) more"
        }
    }

    // MARK: - Initialization

    init(userId: UUID, selectedDate: Date, repository: SymptomRepositoryProtocol & DailyLogRepositoryProtocol) {
        self.userId = userId
        self.selectedDate = selectedDate
        self.repository = repository

        loadPeriodSymptoms()
        loadDataForSelectedDate()
    }

    // MARK: - Data Loading

    private func loadPeriodSymptoms() {
        let periodSymptomNames = ["Cramps", "Bloating", "Breast soreness"]
        let allSymptoms = repository.allSymptoms

        periodSymptoms = allSymptoms.filter { periodSymptomNames.contains($0.name) }
            .sorted { $0.displayOrder < $1.displayOrder }
    }

    private func loadDataForSelectedDate() {
        if let existing = repository.dailyLog(for: userId, on: selectedDate) {
            dailyLog = existing
        } else {
            dailyLog = DailyLog(userId: userId, date: selectedDate)
        }

        updateStateFromDailyLog()
    }

    private func updateStateFromDailyLog() {
        guard let log = dailyLog else { return }

        isPeriodLogged = log.flowLevel != nil
        selectedFlowLevel = log.flowLevel

        let periodSymptomIds = Set(periodSymptoms.map { $0.id })
        selectedSymptomIds = Set(log.symptomLogs.map { $0.symptomId })
            .intersection(periodSymptomIds)
        areSymptomsLogged = !selectedSymptomIds.isEmpty

        isSpottingLogged = log.hadSpotting
    }

    // MARK: - Period Actions

    func togglePeriodLogged() {
        if isPeriodLogged {
            unlogPeriod()
        } else {
            isPeriodLogged = true
            isPeriodExpanded = true
        }

        savePeriodData()
    }

    func selectFlowLevel(_ level: FlowLevel) {
        if selectedFlowLevel == level {
            selectedFlowLevel = nil
        } else {
            selectedFlowLevel = level
        }

        isPeriodLogged = true
        savePeriodData()
    }

    func togglePeriodExpanded() {
        isPeriodExpanded.toggle()
    }

    private func savePeriodData() {
        guard var log = dailyLog else { return }

        log.flowLevel = isPeriodLogged ? selectedFlowLevel : nil

        repository.save(dailyLog: log)
        dailyLog = log
    }
    
    private func unlogPeriod() {
        selectedFlowLevel = nil
        isPeriodLogged = false
        isPeriodExpanded = false
    }

    // MARK: - Symptoms Actions

    func toggleSymptomsLogged() {
        if !areSymptomsLogged {
            areSymptomsLogged = true
            areSymptomsExpanded = true
        }
    }

    func toggleSymptomSelection(_ symptomId: UUID) {
        if selectedSymptomIds.contains(symptomId) {
            if expandedSeveritySymptomId == symptomId {
                expandedSeveritySymptomId = nil
            } else {
                expandedSeveritySymptomId = symptomId
            }
        } else {
            selectedSymptomIds.insert(symptomId)
            areSymptomsLogged = true
            saveSymptomData(for: symptomId, severity: nil)
        }
    }

    func updateSymptomSeverity(_ symptomId: UUID, severity: Severity) {
        saveSymptomData(for: symptomId, severity: severity)
    }

    func toggleSymptomsExpanded() {
        if areSymptomsLogged {
            areSymptomsExpanded.toggle()
        }
    }

    private func saveSymptomData(for symptomId: UUID, severity: Severity?) {
        guard var log = dailyLog else { return }

        log.symptomLogs.removeAll { $0.symptomId == symptomId }

        let symptomLog = SymptomLog(
            userId: userId,
            symptomId: symptomId,
            date: selectedDate,
            timestamp: Date(),
            severity: severity ?? .mild
        )
        log.symptomLogs.append(symptomLog)

        repository.save(dailyLog: log)
        dailyLog = log
        updateStateFromDailyLog()
    }

    // MARK: - Spotting Actions

    func toggleSpotting() {
        isSpottingLogged.toggle()
        saveSpottingData()
    }

    private func saveSpottingData() {
        guard var log = dailyLog else { return }

        log.hadSpotting = isSpottingLogged

        repository.save(dailyLog: log)
        dailyLog = log
    }
}
