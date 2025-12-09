import SwiftUI

struct OnboardingContainerView: View {
    
    @State private var viewModel: OnboardingViewModel
    
    // MARK: - Init
    
    init(onComplete: @escaping () -> Void) {
        self._viewModel = State(initialValue: OnboardingViewModel(onComplete: onComplete))
    }
    
    // MARK: - Body
        
    var body: some View {
        if viewModel.activeScreen == .welcome {
            WelcomeScreenView(onComplete: viewModel.router.advanceFromWelcome)
        } else {
            mainOnboardingContent
        }
    }
    
    // MARK: - Main Onboarding Content
    
    private var mainOnboardingContent: some View {
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
                    }
                    
                    buttonArea
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
                }
            }
            .toolbar {
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
        switch viewModel.router.activeScreen {
        case .welcome:
            EmptyView()
        case .screen1:
            Text("Screen 1 content") // Placeholder
        case .screen2:
            Text("Screen 2 content") // Placeholder
        case .screen3:
            Text("Screen 3 content") // Placeholder
        case .screen4:
            Text("Screen 4 content") // Placeholder
        case .screen5:
            Text("Screen 5 content") // Placeholder
        case .emailCollection:
            Text("Email collection content") // Placeholder
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
        case .welcome: return ""
        case .screen1: return OnboardingCopy.Screen1.buttonTitle
        case .screen2: return OnboardingCopy.Screen2.buttonTitle
        case .screen3: return OnboardingCopy.Screen3.buttonTitle
        case .screen4: return OnboardingCopy.Screen4.buttonTitle
        case .screen5: return OnboardingCopy.Screen5.buttonTitle
        case .emailCollection: return OnboardingCopy.EmailCollection.buttonTitle
        }
    }
}
