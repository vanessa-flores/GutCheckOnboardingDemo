import SwiftUI

struct LoggingContainerView: View {
    let userId: UUID
    @State private var selectedSegment: LogSegment = .symptoms

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Log Type", selection: $selectedSegment) {
                    ForEach(LogSegment.allCases) { segment in
                        Text(segment.title).tag(segment)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                
                Group {
                    switch selectedSegment {
                    case .all:
                        AllLogsPlaceholderView()
                    case .symptoms:
                        SymptomLoggingView(userId: userId)
                    case .cycle:
                        CyclePlaceholderView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Log")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Log Segment Enum

enum LogSegment: String, CaseIterable, Identifiable {
    case all
    case symptoms
    case cycle
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .all: return "All"
        case .symptoms: return "Symptoms"
        case .cycle: return "Cycle"
        }
    }
}

// MARK: - Placeholder Views

struct AllLogsPlaceholderView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.3))
            
            Text("All Logs")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Combined symptom and cycle tracking\ncoming in Phase 2")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct SymptomsPlaceholderView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.3))
            
            Text("Symptom Logging")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Log your tracked symptoms here\nImplementation coming next")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct CyclePlaceholderView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.3))
            
            Text("Cycle Tracking")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("Track your menstrual cycle\ncoming in Phase 2")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    LoggingContainerView(userId: UUID())
}
