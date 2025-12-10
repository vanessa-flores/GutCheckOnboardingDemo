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
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom navigation bar (avoids NavigationStack overhead)
                navigationBar

                if viewModel.showsProgressDots {
                    progressDotsView
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        screenContent
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }

                buttonArea
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
            }
        }
        .gesture(swipeBackGesture)
    }

    // MARK: - Navigation Bar

    private var navigationBar: some View {
        HStack {
            // Back button
            if viewModel.canGoBack {
                Button(action: viewModel.goBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Close button
            Button(action: viewModel.handleSkip) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
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
        Button(action: viewModel.handlePrimaryAction) {
            Text(primaryButtonTitle)
        }
        .buttonStyle(AppTheme.PrimaryButtonStyle())
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    // MARK: - Button Configuration
    
    private var primaryButtonTitle: String {
        switch viewModel.activeScreen {
        case .screen1: return OnboardingCopy.Screen1.buttonTitle
        case .screen2: return OnboardingCopy.Screen2.buttonTitle
        case .screen3: return OnboardingCopy.Screen3.buttonTitle
        case .screen4: return OnboardingCopy.Screen4.buttonTitle
        case .screen5: return OnboardingCopy.Screen5.buttonTitle
        case .emailCollection: return OnboardingCopy.EmailCollection.buttonTitle
        }
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
