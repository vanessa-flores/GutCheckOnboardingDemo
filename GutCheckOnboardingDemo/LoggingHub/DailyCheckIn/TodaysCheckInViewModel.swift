import SwiftUI
import Observation

// MARK: - CheckInTab

enum CheckInTab: String, CaseIterable, Identifiable {
    case mood = "Mood"
    case symptoms = "Symptoms"
    case behaviors = "Behaviors"
    
    var id: String { rawValue }
}

// MARK: - TodaysCheckInViewModel

@Observable
class TodaysCheckInViewModel: SymptomCategorySelectable {

    let userId: UUID
    let date: Date
    private let repository: CheckInRepositoryProtocol

    var selectedTab: CheckInTab = .mood

    var selectedMood: Mood?
    var quickNote: String = ""

    // MARK: - SymptomCategorySelectable Properties

    var selectedSymptomIds: Set<UUID> = []
    var expandedCategories: Set<SymptomCategory> = [
        .digestiveGutHealth,
        .cycleHormonal,
        .energyMoodMental,
        .sleepTemperature
    ]

    private var originalDailyLog: DailyLog?
    private var dailyLog: DailyLog

    var hasUnsavedChanges: Bool {
        guard let original = originalDailyLog else { return hasAnyData }

        let moodChanged = selectedMood != original.mood
        let noteChanged = (quickNote.isEmpty ? nil : quickNote) != original.reflectionNotes

        let originalSymptomIds = Set(original.symptomLogs.map { $0.symptomId })
        let symptomsChanged = selectedSymptomIds != originalSymptomIds

        return moodChanged || noteChanged || symptomsChanged
    }

    var hasAnyData: Bool {
        selectedMood != nil || !quickNote.isEmpty || !selectedSymptomIds.isEmpty
    }

    var symptomsByCategory: [(category: SymptomCategory, symptoms: [Symptom])] {
        repository.symptomsGroupedByCategory()
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    init(userId: UUID, date: Date, repository: CheckInRepositoryProtocol) {
        self.userId = userId
        self.date = date
        self.repository = repository

        let existingLog = repository.dailyLog(for: userId, on: date)
        self.originalDailyLog = existingLog
        self.dailyLog = existingLog ?? DailyLog(userId: userId, date: date)

        if let existing = existingLog {
            self.selectedMood = existing.mood
            self.quickNote = existing.reflectionNotes ?? ""
            self.selectedSymptomIds = Set(existing.symptomLogs.map { $0.symptomId })
        }
    }
    
    func selectTab(_ tab: CheckInTab) {
        selectedTab = tab
    }
    
    func selectMood(_ mood: Mood) {
        if selectedMood == mood {
            selectedMood = nil
        } else {
            selectedMood = mood
        }
    }

    // Note: toggleSymptom, toggleCategory, isCategoryExpanded, and isSymptomSelected
    // are provided by SymptomCategorySelectable protocol extension

    func save() {
        var updatedLog = dailyLog
        
        updatedLog.mood = selectedMood
        updatedLog.reflectionNotes = quickNote.isEmpty ? nil : quickNote
        
        let existingSymptomIds = Set(updatedLog.symptomLogs.map { $0.symptomId })
        let symptomsToRemove = existingSymptomIds.subtracting(selectedSymptomIds)
        let symptomsToAdd = selectedSymptomIds.subtracting(existingSymptomIds)
        
        updatedLog.symptomLogs.removeAll { symptomsToRemove.contains($0.symptomId) }
        
        for symptomId in symptomsToAdd {
            let newLog = SymptomLog(
                id: UUID(),
                userId: userId,
                symptomId: symptomId,
                date: date.startOfDay,
                timestamp: Date(),
                severity: nil,
                notes: nil
            )
            updatedLog.symptomLogs.append(newLog)
        }
        
        repository.save(dailyLog: updatedLog)
        
        self.dailyLog = updatedLog
        self.originalDailyLog = updatedLog
    }
}
