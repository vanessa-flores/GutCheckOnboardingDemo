import SwiftUI

struct SelectableRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(AppTheme.Colors.primaryAction)
                        .fontWeight(.bold)
                }
            }
        }
        .listRowBackground(AppTheme.Colors.surface)
    }
}

#Preview {
    List {
        SelectableRow(
            title: "Selected Option",
            isSelected: true,
            action: {}
        )

        SelectableRow(
            title: "Unselected Option",
            isSelected: false,
            action: {}
        )
    }
}
