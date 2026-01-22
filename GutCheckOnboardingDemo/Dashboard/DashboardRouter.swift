import SwiftUI
import Observation

@Observable
class DashboardRouter {

    // MARK: - Published State

    // Currently no navigation state needed since NavigationStack handles path internally
    // Future: Add navigationPath or other state as Dashboard features expand

    // MARK: - Navigation Actions

    // Future: Add helper methods for navigation as needed
    // Example: func navigateToSettings() { ... }

    func reset() {
        // Reset any navigation state
        // Currently no state to reset, but included for consistency with router pattern
    }
}

// MARK: - Dashboard Route

enum DashboardRoute: Hashable {
    case gettingStarted
}
