import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // MARK: Primary Colors
        /// Soft Sage Green - Use for primary CTAs, active states, key data points
        static let primaryAction = Color(hex: "7BA591")
        
        /// Warm Off-White - Use for main backgrounds, cards
        static let background = Color(hex: "F8F6F3")
        
        // MARK: Secondary Colors
        /// Warm Sand - Use for secondary buttons, highlights, icons
        static let accent = Color(hex: "D4A574")
        
        // MARK: Text Colors
        /// Deep Forest - Use for headers, body text
        static let textPrimary = Color(hex: "2D3E3A")
        
        /// Muted Teal-Grey - Use for secondary text, captions
        static let textSecondary = Color(hex: "6B7B77")
        
        // MARK: Utility Colors
        /// Light Mint - Use for success states
        static let success = Color(hex: "8BB89D")
        
        /// Peachy Tan - Use for warning states
        static let warning = Color(hex: "E8B98F")
        
        /// Dusty Rose - Use for error states (not bright red)
        static let error = Color(hex: "C89090")
        
        /// Pale Teal - Use for info states
        static let info = Color(hex: "A8BFC4")
        
        // MARK: Semantic Colors (for specific use cases)
        /// Pure white for elevated cards/surfaces
        static let surface = Color.white
        
        /// Primary action with opacity for disabled states
        static let primaryActionDisabled = Color(hex: "7BA591").opacity(0.4)
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
        
        /// Button with Dynamic Type - scales from 17pt base
        static func buttonDynamic() -> Font {
            Font.custom("SF Pro Display", size: 17, relativeTo: .headline).weight(.semibold)
        }
        
        // MARK: Letter Spacing Helpers
        /// Use for large titles (48pt) - tracking value: -0.96 (2% of font size)
        static let largeTitleTracking: CGFloat = -0.96
        
        /// Use for titles (32pt) - tracking value: -0.32 (1% of font size)
        static let titleTracking: CGFloat = -0.32
        
        // MARK: Usage Note
        // Use static properties (e.g., .largeTitle) for fixed sizes
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
        
        /// 60pt - Bottom safe area padding (for buttons)
        static let bottomSafeArea: CGFloat = 60
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
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.textSecondary.opacity(0.3), lineWidth: 1)
                )
                .opacity(configuration.isPressed ? 0.7 : 1.0)
                .animation(.easeInOut(duration: AppTheme.Animation.quick), value: configuration.isPressed)
        }
    }
}
