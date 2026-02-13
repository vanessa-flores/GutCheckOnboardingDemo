import SwiftUI

struct GettingStartedContainerView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GettingStartedViewModel
    let userId: UUID

    // MARK: - Init

    init(userId: UUID, onComplete: @escaping () -> Void) {
        self.userId = userId
        self._viewModel = State(initialValue: GettingStartedViewModel(onComplete: onComplete))
    }
    
    // MARK: - Body
    
    var body: some View {
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
            ToolbarItem(placement: .topBarLeading) {
                Button(action: handleBackAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            ToolbarItem(placement: .principal) {
                progressDotsView
            }
        }
        .onChange(of: viewModel.isGettingStartedComplete) { _, isComplete in
            if isComplete {
                dismiss()
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
                          : AppTheme.Colors.textSecondary.opacity(AppTheme.Animation.quick))
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
            GutHealthAwarenessView(
                contentOffset: viewModel.contentOffset,
                viewModel: viewModel
            )
        case .menstrualCycleStatus:
            MestrualCycleStatusView(
                contentOffset: viewModel.contentOffset,
                viewModel: viewModel
            )
        case .symptomSelection:
            SymptomSelectionView(
                contentOffset: viewModel.contentOffset,
                viewModel: viewModel
            )
        }
    }
    
    // MARK: - Button Area

    private var buttonArea: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Button(action: viewModel.handlePrimaryAction) {
                Text(viewModel.primaryButtonTitle)
                    .foregroundStyle(AppTheme.Colors.textOnPrimary)
            }
            .buttonStyle(AppTheme.PrimaryButtonStyle())
            .disabled(!viewModel.isPrimaryButtonEnabled)
        }
        .padding(.top, AppTheme.Spacing.md)
    }
    
    // MARK: - Navigation

    private func handleBackAction() {
        if viewModel.router.activeScreen == .goalsMotivations {
            viewModel.router.reset()
            dismiss()
        } else {
            viewModel.goBack()
        }
    }

    private var swipeBackGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.width > 100 {
                    handleBackAction()
                }
            }
    }
}

// MARK: - Preview

#Preview {
    GettingStartedContainerView(userId: UUID(), onComplete: {})
}
