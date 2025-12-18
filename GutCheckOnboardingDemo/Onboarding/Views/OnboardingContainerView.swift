import SwiftUI

struct OnboardingContainerView: View {

    @State private var viewModel: OnboardingViewModel
    @FocusState private var isEmailFocused: Bool

    // MARK: - Init

    init(onComplete: @escaping () -> Void) {
        self._viewModel = State(initialValue: OnboardingViewModel(onComplete: onComplete))
    }

    // MARK: - Body

    var body: some View {
        
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.showsProgressDots {
                        progressDotsView
                    }
                    
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
                                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.handleSkip) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Progress Dots
    
    private var progressDotsView: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            ForEach(0..<AppTheme.ComponentSizes.onboardingScreenCount, id: \.self) { index in
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
        case .screen1:
            Screen1ContentView(contentOffset: viewModel.contentOffset)
        case .screen2:
            Screen2ContentView(contentOffset: viewModel.contentOffset)
        case .screen3:
            Screen3ContentView(contentOffset: viewModel.contentOffset)
        case .screen4:
            Screen4ContentView(
                contentOffset: viewModel.contentOffset,
                selectedSymptoms: $viewModel.selectedSymptoms,
                otherText: $viewModel.otherText
            )
        case .screen5:
            Screen5ContentView(contentOffset: viewModel.contentOffset)
        case .emailCollection:
            EmailCollectionContentView(
                contentOffset: viewModel.contentOffset,
                email: $viewModel.email,
                showEmailError: $viewModel.showEmailError,
                isEmailFocused: $isEmailFocused,
                onSubmit: viewModel.handlePrimaryAction
            )
        }
    }
    
    // MARK: - Button Area

    private var buttonArea: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Button(action: viewModel.handlePrimaryAction) {
                Text(viewModel.primaryButtonTitle)
            }
            .buttonStyle(AppTheme.PrimaryButtonStyle())

            if let secondaryConfig = viewModel.secondaryButtonConfig {
                Button(action: secondaryConfig.action) {
                    Text(secondaryConfig.title)
                }
                .buttonStyle(AppTheme.SecondaryButtonStyle())
            }
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

#Preview {
    OnboardingContainerView(onComplete: {})
}
