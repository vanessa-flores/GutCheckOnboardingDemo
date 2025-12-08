import SwiftUI

struct EmailCollectionView: View {
    var appRouter: AppRouter
    
    @State private var email: String = ""
    @State private var showError: Bool = false
    @FocusState private var isEmailFocused: Bool
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Stay connected")
                            .font(AppTheme.Typography.title)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tracking(AppTheme.Typography.titleTracking)
                            .padding(.top, 100)
                            .padding(.bottom, AppTheme.Spacing.lg)
                        
                        Text("Get helpful tips as you start tracking—no fluff, just what works.")
                            .font(AppTheme.Typography.bodyLarge)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineSpacing(10)
                            .padding(.bottom, AppTheme.Spacing.xl)
                        
                        TextField("", text: $email, prompt: Text("your@email.com"))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .tint(AppTheme.Colors.primaryAction)
                            .padding(AppTheme.Spacing.md)
                            .background(Color.white)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                    .stroke(showError ? AppTheme.Colors.error : AppTheme.Colors.textSecondary, lineWidth: 2)
                            )
                            .focused($isEmailFocused)
                            .onChange(of: email) { oldValue, newValue in
                                if showError {
                                    showError = false
                                }
                            }
                            .onSubmit {
                                handleGetStarted()
                            }
                        
                        if showError {
                            Text("Please enter a valid email address")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.error)
                                .padding(.top, AppTheme.Spacing.xs)
                        }
                        
                        VStack(spacing: 0) {
                            Button("Get started") {
                                handleGetStarted()
                            }
                            .buttonStyle(AppTheme.PrimaryButtonStyle())
                            
                            Button("Maybe later") {
                                appRouter.completeOnboarding()
                            }
                            .font(AppTheme.Typography.bodySmall)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .padding(.top, AppTheme.Spacing.sm)
                        }
                        .padding(.top, AppTheme.Spacing.xl)
                        .padding(.bottom, AppTheme.Spacing.bottomSafeArea)
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    appRouter.completeOnboarding()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleGetStarted() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        // If email is empty, that's fine (optional field)
        if trimmedEmail.isEmpty {
            appRouter.completeOnboarding()
            return
        }
        
        // If email is provided, validate it
        if isValidEmail(trimmedEmail) {
            // TODO: Save to user_profile.email via Supabase
            print("Saving email: \(trimmedEmail)")
            appRouter.completeOnboarding()
        } else {
            showError = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", AppTheme.Validation.emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    NavigationStack {
        EmailCollectionView(appRouter: AppRouter())
    }
}
