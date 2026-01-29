import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // MARK: Primary Colors
        /// Sage Green - Primary CTAs, active states
        static let primaryAction = Color("PrimaryAction")
        /// Screen backgrounds
        static let background = Color("Background")
        
        // MARK: - Accent Colors
        /// Warm Sand - Secondary buttons, highlights
        static let accent = Color("Accent")
        /// Accent as background (darker in dark mode for containers)
        static let accentBackground = Color("AccentBackground")
        
        // MARK: Text Colors
        /// Deep Forest - Headers, body text
        static let textPrimary = Color("TextPrimary")
        /// Muted Teal-Grey - Captions, secondary text
        static let textSecondary = Color("TextSecondary")
        /// Text on primary action buttons
        static let textOnPrimary = Color("TextOnPrimary")
        /// Text on accent backgrounds
        static let textOnAccent = Color("TextOnAccent")
        
        // MARK: - Utility Colors
            
        /// Light Mint / Sage - Success states background
        static let success = Color("Success")
        /// Text on success backgrounds
        static let textOnSuccess = Color("TextOnSuccess")
        /// Peachy Tan / Warm Amber - Warning states background
        static let warning = Color("Warning")
        /// Text on warning backgrounds
        static let textOnWarning = Color("TextOnWarning")
        /// Dusty Rose - Error states background
        static let error = Color("Error")
        /// Text on error backgrounds
        static let textOnError = Color("TextOnError")
        /// Pale Teal - Info states background
        static let info = Color("Info")
        /// Text on info backgrounds
        static let textOnInfo = Color("TextOnInfo")
        
        // MARK: - Other
            
        /// Dividers, borders
        static let separator = Color("Separator")
        /// Cards, elevated surfaces
        static let surface = Color("Surface")
        /// Grouped backgrounds, table cells
        static let surfaceSecondary = Color("SurfaceSecondary")
        /// Disabled primary action state
        static let primaryActionDisabled = Color("PrimaryAction").opacity(0.4)
    }
    
    // MARK: - Typography
    struct Typography {
        // MARK: Display & Titles
        /// 48pt Bold - Use for welcome screen, major headlines
        /// Scales with accessibility settings relative to .largeTitle
        static let largeTitle = Font.system(size: 48, weight: .bold).width(.standard)
        
        /// 32pt Bold - Use for onboarding headlines, screen titles
        /// Scales with accessibility settings relative to .title
        static let title = Font.system(size: 32, weight: .bold).width(.standard)
        
        /// 24pt Bold - Use for section headers
        /// Scales with accessibility settings relative to .title2
        static let title2 = Font.system(size: 24, weight: .bold).width(.standard)
        
        /// 20pt SemiBold - Use for card titles, list headers
        /// Scales with accessibility settings relative to .title3
        static let title3 = Font.system(size: 20, weight: .semibold).width(.standard)
        
        // MARK: Body Text
        /// 20pt Regular - Use for emphasized body copy (onboarding, validation messages)
        /// Scales with accessibility settings relative to .body
        static let bodyLarge = Font.system(size: 20, weight: .regular).width(.standard)
        
        /// 18pt Regular - Use for standard body text
        /// Scales with accessibility settings relative to .body
        static let body = Font.system(size: 18, weight: .regular).width(.standard)

        /// 17pt Regular - Use for form options, list items in Getting Started
        /// Scales with accessibility settings relative to .body
        static let bodyMedium = Font.system(size: 17, weight: .regular).width(.standard)

        /// 16pt Regular - Use for secondary body text
        /// Scales with accessibility settings relative to .callout
        static let bodySmall = Font.system(size: 16, weight: .regular).width(.standard)
        
        // MARK: UI Elements
        /// 17pt SemiBold - Use for primary buttons
        /// Scales with accessibility settings relative to .headline
        static let button = Font.system(size: 17, weight: .semibold).width(.standard)
        
        /// 15pt Medium - Use for secondary buttons, tabs
        /// Scales with accessibility settings relative to .subheadline
        static let buttonSecondary = Font.system(size: 15, weight: .medium).width(.standard)
        
        // MARK: Supporting Text
        /// 14pt Regular - Use for captions, helper text
        /// Scales with accessibility settings relative to .footnote
        static let caption = Font.system(size: 14, weight: .regular).width(.standard)
        
        /// 12pt Regular - Use for timestamps, metadata
        /// Scales with accessibility settings relative to .caption
        static let caption2 = Font.system(size: 12, weight: .regular).width(.standard)
        
        // MARK: Dynamic Type Scaling Variants
        // For views that need explicit Dynamic Type control, use these:
        
        /// Large title with Dynamic Type - scales from 48pt base
        static func largeTitleDynamic() -> Font {
            Font.custom("SF Pro Display", size: 48, relativeTo: .largeTitle).weight(.bold)
        }
        
        /// Title with Dynamic Type - scales from 32pt base
        static func titleDynamic() -> Font {
            Font.custom("SF Pro Display", size: 32, relativeTo: .title).weight(.bold)
        }
        
        /// Body large with Dynamic Type - scales from 20pt base
        static func bodyLargeDynamic() -> Font {
            Font.custom("SF Pro Display", size: 20, relativeTo: .body)
        }
        
        /// Body with Dynamic Type - scales from 18pt base
        static func bodyDynamic() -> Font {
            Font.custom("SF Pro Display", size: 18, relativeTo: .body)
        }

        /// Body medium with Dynamic Type - scales from 17pt base
        static func bodyMediumDynamic() -> Font {
            Font.custom("SF Pro Display", size: 17, relativeTo: .body)
        }

        /// Button with Dynamic Type - scales from 17pt base
        static func buttonDynamic() -> Font {
            Font.custom("SF Pro Display", size: 17, relativeTo: .headline).weight(.semibold)
        }
        
        // MARK: Letter Spacing Helpers
        /// Use for large titles (48pt) - tracking value: -0.96 (2% of font size)
        static let largeTitleTracking: CGFloat = -0.96
        
        /// Use for titles (32pt) - tracking value: -0.32 (1% of font size)
        static let titleTracking: CGFloat = -0.32
        
        /// Use for titles (24pt) - tracking value: -0.24 (1% of font size)
        static let title2Tracking: CGFloat = -0.24
        
        // MARK: Usage Note
        // Use static properties (e.g., .largeTitle, .bodyMedium) for fixed sizes
        // Use functions (e.g., .largeTitleDynamic()) when you need Dynamic Type support
    }
    
    // MARK: - Spacing
    struct Spacing {
        /// 4pt - Minimal spacing (very tight)
        static let xxs: CGFloat = 4
        
        /// 8pt - Extra small spacing
        static let xs: CGFloat = 8
        
        /// 12pt - Small spacing
        static let sm: CGFloat = 12
        
        /// 16pt - Medium spacing (standard between elements)
        static let md: CGFloat = 16
        
        /// 20pt - Medium-large spacing
        static let lg: CGFloat = 20
        
        /// 24pt - Large spacing
        static let xl: CGFloat = 24
        
        /// 32pt - Extra large spacing (between sections)
        static let xxl: CGFloat = 32
        
        /// 40pt - Huge spacing (screen edges)
        static let xxxl: CGFloat = 40
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        /// 8pt - Small radius (chips, tags)
        static let small: CGFloat = 8
        
        /// 12pt - Medium radius (buttons, inputs)
        static let medium: CGFloat = 12
        
        /// 16pt - Large radius (cards, containers)
        static let large: CGFloat = 16
        
        /// 20pt - Extra large radius (modals, sheets)
        static let xlarge: CGFloat = 20
    }
    
    // MARK: - Animation Durations
    struct Animation {
        /// 0.2s - Quick interactions (button press, hover)
        static let quick: Double = 0.2

        /// 0.35s - Standard transitions (screen navigation)
        static let standard: Double = 0.35

        /// 0.6s - Slower fade-ins (secondary content)
        static let slow: Double = 0.6

        /// 0.8s - Emphasis animations (primary content reveal)
        static let emphasis: Double = 0.8

        // MARK: Welcome Screen Timing
        /// Duration for app name fade-in animation
        static let welcomeAppNameDuration: Double = 0.8

        /// Delay before tagline appears after app name
        static let welcomeTaglineDelay: Double = 1.2

        /// Duration for tagline and accent line fade-in
        static let welcomeTaglineDuration: Double = 0.8

        /// Total time before auto-advancing from welcome screen
        static let welcomeAutoAdvanceDelay: Double = 4.0

        // MARK: Onboarding Container Transitions
        /// Duration for content fade out when navigating forward
        static let contentFadeOut: Double = 0.2

        /// Duration for each element to fade in
        static let contentFadeIn: Double = 0.2

        /// Delay between staggered element animations
        static let contentStagger: Double = 1.0

        /// Duration for horizontal slide transition (back navigation)
        static let slideTransition: Double = 0.2
    }

    // MARK: - Component Sizes
    struct ComponentSizes {
        // MARK: Progress Indicator
        /// Number of onboarding content screens (excluding welcome and email)
        static let onboardingScreenCount: Int = 5

        /// Size of progress indicator dots
        static let progressDotSize: CGFloat = 8

        // MARK: Checkbox
        /// Size of checkbox container
        static let checkboxSize: CGFloat = 24

        /// Corner radius for checkbox
        static let checkboxCornerRadius: CGFloat = 6

        /// Size of checkmark icon inside checkbox
        static let checkmarkIconSize: CGFloat = 14

        // MARK: Text Input
        /// Height for multi-line text editor
        static let textEditorHeight: CGFloat = 96

        // MARK: Illustrations
        /// Standard height for illustration placeholders
        static let illustrationHeight: CGFloat = 180

        /// Smaller height for compact illustrations
        static let illustrationHeightCompact: CGFloat = 140
    }

    // MARK: - Validation
    struct Validation {
        /// Email validation regex pattern
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    // MARK: - Button Styles
    /// Primary button style using theme colors and spacing
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(AppTheme.Typography.button)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    configuration.isPressed
                        ? AppTheme.Colors.primaryAction.opacity(0.8)
                        : AppTheme.Colors.primaryAction
                )
                .cornerRadius(AppTheme.CornerRadius.medium)
                .animation(.easeInOut(duration: AppTheme.Animation.quick), value: configuration.isPressed)
        }
    }
    
    /// Secondary button style using theme colors
    struct SecondaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(AppTheme.Typography.buttonSecondary)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.vertical, AppTheme.Spacing.xxs)
                .padding(.horizontal, AppTheme.Spacing.xxs)
                .background(Color.clear)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
                .animation(.easeInOut(duration: AppTheme.Animation.quick), value: configuration.isPressed)
        }
    }
}
