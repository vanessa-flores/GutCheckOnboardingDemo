import SwiftUI

struct LoggingContainerView: View {
    let userId: UUID
    let appRouter: AppRouter
    @State private var selectedSegment: LogSegment = .quickLog

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
                    case .quickLog:
                        QuickLogView(userId: userId, appRouter: appRouter)
                    case .allSymptoms:
                        SymptomLoggingView(userId: userId)
                    case .cycle:
                        CycleTrackingView(userId: userId)
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
    case quickLog
    case allSymptoms
    case cycle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .quickLog: return "Quick Log"
        case .allSymptoms: return "All Symptoms"
        case .cycle: return "Cycle"
        }
    }
}

// MARK: - Placeholder Views

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
    LoggingContainerView(userId: UUID(), appRouter: AppRouter())
}
