import SwiftUI

// MARK: - Reusable Text Components

struct GettingStartedHeadline: View {
    let text: String
    let offset: CGFloat

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.title2)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .tracking(AppTheme.Typography.title2Tracking)
            .padding(.bottom, AppTheme.Spacing.sm)
            .onboardingAnimated(offset: offset)
    }
}

struct GettingStartedHelperText: View {
    let text: String
    let offset: CGFloat
    let bottomPadding: CGFloat?

    init(text: String, offset: CGFloat, bottomPadding: CGFloat? = nil) {
        self.text = text
        self.offset = offset
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        Text(text)
            .font(AppTheme.Typography.bodySmall)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .lineSpacing(10)
            .padding(.bottom, bottomPadding ?? 0)
            .onboardingAnimated(offset: offset)
    }
}


// MARK: - Screen Layout Scaffold

struct GettingStartedScreenLayout<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
    }
}

// MARK: - Goals/Motivations

struct GoalsAndMotivationsView: View {
    let contentOffset: CGFloat
    @Bindable var viewModel: GettingStartedViewModel

    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.GoalsAndMotivations.headline,
                offset: contentOffset
            )
            
            GettingStartedHelperText(
                text: GettingStartedCopy.GoalsAndMotivations.helperText,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.md
            )

            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(GettingStartedCopy.GoalsAndMotivations.options) { option in
                    SelectableCard(
                        text: option.description,
                        isSelected: viewModel.selectedGoals.contains(option),
                        onTap: {
                            viewModel.toggleGoal(option)
                        }
                    )
                    .onboardingAnimated(offset: contentOffset)
                }
            }
        }
    }
}

// MARK: - Gut Health Awareness

struct GutHealthAwarenessView: View {
    let contentOffset: CGFloat
    
    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.GutHealthAwareness.headline,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Mestrual Cycle Status

struct MestrualCycleStatusView: View {
    let contentOffset: CGFloat
    
    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.MenstrualCycleStatus.headline,
                offset: contentOffset
            )
        }
    }
}

// MARK: - Symptom Selection

struct SymptomSelectionView: View {
    let contentOffset: CGFloat
    
    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.SymptomSelection.headline,
                offset: contentOffset
            )
        }
    }
}
