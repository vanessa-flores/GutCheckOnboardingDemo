import SwiftUI

// MARK: - ActiveModal

private enum ActiveModal: String, Identifiable {
    case todaysCheckIn
    // Future: periodLog, symptomLog
    
    var id: String { rawValue }
}

// MARK: - Logging Hub View

struct LoggingHubView: View {
    let userId: UUID
    @State private var activeModal: ActiveModal?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Section Header
                    HStack {
                        Text("Log Today")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.top, AppTheme.Spacing.lg)
                    .padding(.bottom, AppTheme.Spacing.sm)
                    
                    // Action Cards
                    VStack(spacing: AppTheme.Spacing.sm) {
                        LogActionCard(
                            icon: "drop.fill",
                            title: "Log period",
                            subtitle: "Track your flow"
                        ) {
                            // TODO: Navigate to period logging
                            print("Log period tapped")
                        }
                        
                        LogActionCard(
                            icon: "stethoscope",
                            title: "Log symptom",
                            subtitle: "Quick symptom capture"
                        ) {
                            // TODO: Navigate to symptom logging
                            print("Log symptom tapped")
                        }
                        
                        LogActionCard(
                            icon: "person.fill.checkmark",
                            title: "Today's check-in",
                            subtitle: "Review your whole day"
                        ) {
                            activeModal = .todaysCheckIn
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Log")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $activeModal) { modal in
            switch modal {
            case .todaysCheckIn:
                TodaysCheckInModal(
                    userId: userId,
                    repository: InMemorySymptomRepository.shared
                )
            }
        }
    }
}

// MARK: - Log Action Card

struct LogActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primaryAction.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primaryAction)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.Typography.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Logging Hub") {
    LoggingHubView(
        userId: UUID()
    )
}

#Preview("Log Action Card") {
    VStack(spacing: 12) {
        LogActionCard(
            icon: "drop.fill",
            title: "Log period",
            subtitle: "Track your flow"
        ) {
            print("Tapped")
        }
        
        LogActionCard(
            icon: "stethoscope",
            title: "Log symptom",
            subtitle: "Quick symptom capture"
        ) {
            print("Tapped")
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}
