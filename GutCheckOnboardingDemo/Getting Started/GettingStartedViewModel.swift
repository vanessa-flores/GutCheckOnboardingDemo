import SwiftUI
import Observation

@Observable
class GettingStartedViewModel {
    
    // Navigation
    var router: GettingStartedRouter
    
    // Animation State
    var contentOffset: CGFloat = 0
    var showContent: Bool = true
    let screenWidth = UIScreen.main.bounds.width

    // MARK: - Question State

    var selectedGoals: Set<GettingStartedCopy.GoalsAndMotivations.Option> = []
    var selectedGutHealthAwareness: GettingStartedCopy.GutHealthAwareness.Option? = nil
    var selectedCycleStatus: GettingStartedCopy.MenstrualCycleStatus.Option? = nil
    var selectedSymptomIds: Set<UUID> = []

    // Flow completion state
    var isGettingStartedComplete: Bool = false

    // MARK: - Private Properties
    
    private let onComplete: () -> Void
    
    // MARK: - Computed Properties
    
    var activeScreen: GettingStartedScreen {
        router.activeScreen
    }
    
    var progressIndex: Int {
        router.activeScreen.progressIndex
    }
    
    var screenCount: Int {
        return 4
    }
    
    var canGoBack: Bool {
        router.canGoBack
    }

    var selectedSymptomCount: Int {
        selectedSymptomIds.count
    }

    // MARK: - Button Configuration

    var primaryButtonTitle: String {
        switch router.activeScreen {
        case .goalsMotivations: return GettingStartedCopy.GoalsAndMotivations.buttonTitle
        case .gutHealthAwareness: return GettingStartedCopy.GutHealthAwareness.buttonTitle
        case .menstrualCycleStatus: return GettingStartedCopy.MenstrualCycleStatus.buttonTitle
        case .symptomSelection: return GettingStartedCopy.SymptomSelection.buttonTitle
        }
    }

    var isPrimaryButtonEnabled: Bool {
        switch router.activeScreen {
        case .goalsMotivations:
            return !selectedGoals.isEmpty
        case .gutHealthAwareness:
            return true // Always enabled for single-select
        case .menstrualCycleStatus:
            return true // Always enabled for single-select
        case .symptomSelection:
            return !selectedSymptomIds.isEmpty
        }
    }

    // MARK: - Init
    
    init(router: GettingStartedRouter = GettingStartedRouter(), onComplete: @escaping () -> Void) {
        self.router = router
        self.onComplete = onComplete
    }
    
    // MARK: - Actions

    func toggleGoal(_ goal: GettingStartedCopy.GoalsAndMotivations.Option) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }

    func selectGutHealthAwareness(_ option: GettingStartedCopy.GutHealthAwareness.Option) {
        selectedGutHealthAwareness = option
    }

    func selectCycleStatus(_ option: GettingStartedCopy.MenstrualCycleStatus.Option) {
        selectedCycleStatus = option
    }

    func toggleSymptom(_ symptomId: UUID) {
        if selectedSymptomIds.contains(symptomId) {
            selectedSymptomIds.remove(symptomId)
        } else {
            selectedSymptomIds.insert(symptomId)
        }
    }

    func handlePrimaryAction() {
        switch router.activeScreen {
        case .symptomSelection:
            handleSymptomSelection()
        default:
            animateForward { [weak self] in
                self?.router.goToNextScreen()
            }
        }
    }
    
    func goBack() {
        animateBackward { [weak self] in
            self?.router.goBack()
        }
    }
    
    func completeGettingStarted() {
        onComplete()
        isGettingStartedComplete = true
    }
    
    // MARK: - Animations
    
    private func animateForward(completion: @escaping () -> Void) {
        // Slide current content out to left
        withAnimation(.easeOut(duration: 0.2)) {
            contentOffset = -screenWidth
        }

        // After slide out, change screen and prepare new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            completion()
            self.contentOffset = self.screenWidth

            // Slide new content in from right
            withAnimation(.easeOut(duration: 0.2)) {
                self.contentOffset = 0
            }
        }
    }
    
    private func animateBackward(completion: @escaping () -> Void) {
        // Slide current content out to right
        withAnimation(.easeOut(duration: 0.2)) {
            contentOffset = screenWidth
        }

        // After slide out, change screen and prepare new content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            completion()
            self.contentOffset = -self.screenWidth

            // Slide new content in from left
            withAnimation(.easeOut(duration: 0.2)) {
                self.contentOffset = 0
            }
        }
    }
    
    private func handleSymptomSelection() {
        print("Saving \(selectedSymptomIds.count) selected symptoms...")
        completeGettingStarted()
    }
}
