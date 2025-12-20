import SwiftUI

struct GettingStartedContainerView: View {
    
    @State private var viewModel: GettingStartedViewModel
    
    // MARK: - Init

    init(onComplete: @escaping () -> Void) {
        self._viewModel = State(initialValue: GettingStartedViewModel(onComplete: onComplete))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            screenContent
                        }
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding([.top, .bottom], AppTheme.Spacing.md)
                    }
                    
                    buttonArea
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.md)
                }
            }
            .gesture(swipeBackGesture)
            .toolbar {
                if viewModel.canGoBack {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: viewModel.goBack) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                    }
                }
                                
                ToolbarItem(placement: .principal) {
                    progressDotsView
                }
            }
        }
    }
    
    // MARK: - Progress Dots
    
    private var progressDotsView: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            ForEach(0..<viewModel.screenCount, id: \.self) { index in
                Circle()
                    .fill(index == viewModel.progressIndex
                        ? AppTheme.Colors.primaryAction
                        : AppTheme.Colors.textSecondary.opacity(0.3))
                    .frame(
                        width: AppTheme.ComponentSizes.progressDotSize,
                        height: AppTheme.ComponentSizes.progressDotSize
                    )
            }
        }
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.md)
    }
    
    // MARK: - Screen Content

    @ViewBuilder
    private var screenContent: some View {
        switch viewModel.activeScreen {
        case .goalsMotivations:
            GoalsAndMotivationsView(
                contentOffset: viewModel.contentOffset,
                viewModel: viewModel
            )
        case .gutHealthAwareness:
            GutHealthAwarenessView(contentOffset: viewModel.contentOffset)
        case .menstrualCycleStatus:
            MestrualCycleStatusView(contentOffset: viewModel.contentOffset)
        case .symptomSelection:
            SymptomSelectionView(contentOffset: viewModel.contentOffset)
        }
    }
    
    // MARK: - Button Area

    private var buttonArea: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Button(action: viewModel.handlePrimaryAction) {
                Text(viewModel.primaryButtonTitle)
            }
            .buttonStyle(AppTheme.PrimaryButtonStyle())
            .disabled(!viewModel.isPrimaryButtonEnabled)
        }
        .padding(.top, AppTheme.Spacing.md)
    }
    
    // MARK: - Navigation Gesture
    
    private var swipeBackGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.width > 100 && viewModel.canGoBack {
                    viewModel.goBack()
                }
            }
    }
}

// MARK: - Preview

#Preview {
    GettingStartedContainerView(onComplete: {})
}
