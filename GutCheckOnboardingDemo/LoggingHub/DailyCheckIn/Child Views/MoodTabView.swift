import SwiftUI

// MARK: - MoodTabView

struct MoodTabView: View {
    @Bindable var viewModel: TodaysCheckInViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("How are you feeling today?")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    moodOptions
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "ellipsis.message.fill")
                            .imageScale(.medium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Text("Quick Note")
                            .font(AppTheme.Typography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                    
                    TextField("Any thoughts to capture?", text: $viewModel.quickNote, axis: .vertical)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 1.5)
                        )
                        .lineLimit(2...6)
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "microphone.fill")
                            .imageScale(.medium)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Text("Voice Note")
                            .font(AppTheme.Typography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                    
                    Text("[Voice Note] goes here")
                        .font(AppTheme.Typography.bodySmall)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.primaryAction.opacity(0.08))
                        .cornerRadius(AppTheme.CornerRadius.medium)
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                
                Spacer()
            }
        }
        .background(AppTheme.Colors.surface)
    }
    
    private var moodOptions: some View {
        HStack(spacing: 12) {
            ForEach(Mood.allCases) { mood in
                VStack(spacing: AppTheme.Spacing.xxs) {
                    Text(mood.emoji)
                        .font(.system(size: 40))
                        .frame(width: 60, height: 60)
                    
                    Text(mood.displayName)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.bottom, AppTheme.Spacing.xs)
                }
                .background(
                    viewModel.selectedMood == mood
                        ? AppTheme.Colors.primaryAction.opacity(0.15)
                        : Color.clear
                )
                .cornerRadius(AppTheme.CornerRadius.medium)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.selectMood(mood)
                    }
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Empty State") {
    MoodTabView(
        viewModel: TodaysCheckInViewModel(
            userId: UUID(),
            date: Date(),
            repository: InMemorySymptomRepository.shared
        )
    )
}

#Preview("With Selection") {
    let viewModel = TodaysCheckInViewModel(
        userId: UUID(),
        date: Date(),
        repository: InMemorySymptomRepository.shared
    )
    viewModel.selectedMood = .great
    viewModel.quickNote = "Feeling energized after morning walk"
    
    return MoodTabView(viewModel: viewModel)
}
