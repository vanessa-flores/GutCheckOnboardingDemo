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
    @Bindable var viewModel: GettingStartedViewModel

    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.GutHealthAwareness.headline,
                offset: contentOffset
            )

            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(GettingStartedCopy.GutHealthAwareness.options) { option in
                    SelectableCard(
                        text: option.description,
                        isSelected: viewModel.selectedGutHealthAwareness == option,
                        onTap: {
                            viewModel.selectGutHealthAwareness(option)
                        }
                    )
                    .onboardingAnimated(offset: contentOffset)
                }
            }
        }
    }
}

// MARK: - Mestrual Cycle Status

struct MestrualCycleStatusView: View {
    let contentOffset: CGFloat
    @Bindable var viewModel: GettingStartedViewModel

    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.MenstrualCycleStatus.headline,
                offset: contentOffset
            )

            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(GettingStartedCopy.MenstrualCycleStatus.options) { option in
                    SelectableCard(
                        text: option.description,
                        isSelected: viewModel.selectedCycleStatus == option,
                        onTap: {
                            viewModel.selectCycleStatus(option)
                        }
                    )
                    .onboardingAnimated(offset: contentOffset)
                }
            }
        }
    }
}

// MARK: - Symptom Selection

struct SymptomSelectionView: View {
    let contentOffset: CGFloat
    @Bindable var viewModel: GettingStartedViewModel

    var body: some View {
        GettingStartedScreenLayout {
            GettingStartedHeadline(
                text: GettingStartedCopy.SymptomSelection.headline,
                offset: contentOffset
            )

            GettingStartedHelperText(
                text: GettingStartedCopy.SymptomSelection.helperText,
                offset: contentOffset,
                bottomPadding: AppTheme.Spacing.md
            )

            Text("\(viewModel.selectedSymptomCount) symptoms selected")
                .font(AppTheme.Typography.buttonSecondary)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, AppTheme.Spacing.xl)
                .onboardingAnimated(offset: contentOffset)

            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(viewModel.symptomsByCategory, id: \.category) { item in
                    ExpandableSymptomCategorySection(
                        category: item.category,
                        symptoms: item.symptoms,
                        expandedCategories: $viewModel.expandedCategories,
                        selectedSymptomIds: $viewModel.selectedSymptomIds
                    )
                    .onboardingAnimated(offset: contentOffset)
                }
            }
        }
    }
}

// MARK: - Category Section Component

struct CategorySection: View {
    let category: SymptomCategory
    let symptoms: [Symptom]
    let isExpanded: Bool
    let selectedSymptomIds: Set<UUID>
    let onToggleCategory: () -> Void
    let onToggleSymptom: (UUID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggleCategory) {
                HStack {
                    Text(category.rawValue)
                        .font(AppTheme.Typography.bodySmall)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.vertical, AppTheme.Spacing.md)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            .buttonStyle(PlainHeaderButtonStyle())

            if isExpanded {
                FlowLayout(spacing: AppTheme.Spacing.xs) {
                    ForEach(symptoms) { symptom in
                        SymptomTag(
                            text: symptom.name,
                            isSelected: selectedSymptomIds.contains(symptom.id),
                            onTap: {
                                onToggleSymptom(symptom.id)
                            }
                        )
                    }
                }
                .padding(.top, AppTheme.Spacing.xxs)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.md)
            }
        }
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
}
