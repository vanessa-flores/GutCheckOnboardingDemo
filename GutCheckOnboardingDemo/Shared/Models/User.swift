import Foundation

// MARK: - User Profile

/// Represents the app user's profile and settings.
/// Designed for easy backend integration - swap repository implementation when ready.
struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    var onboardingCompleted: Bool
    var email: String?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        onboardingCompleted: Bool = false,
        email: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.onboardingCompleted = onboardingCompleted
        self.email = email
    }
}

// MARK: - User Extensions

extension User {
    /// Creates a new user with default values
    static func newUser() -> User {
        User()
    }

    /// Returns a copy with onboarding marked complete
    func withOnboardingCompleted() -> User {
        var copy = self
        copy.onboardingCompleted = true
        return copy
    }

    /// Returns a copy with updated email
    func withEmail(_ email: String?) -> User {
        var copy = self
        copy.email = email
        return copy
    }
}
