import SwiftUI

/// Placeholder view for illustration (rounded rectangle style)
/// Used during development before actual illustrations are added
struct IllustrationPlaceholder: View {
    let height: CGFloat
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.primaryAction.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.3))
                )

            Text(text)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.primaryAction.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(height: height)
    }
}

#Preview {
    IllustrationPlaceholder(height: 180, text: "Sample illustration")
        .padding()
}
