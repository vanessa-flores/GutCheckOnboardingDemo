import SwiftUI

struct LogData {
    let selectedDate: String // "Wed, Jan 8"
    let periodValue: String? // "Medium Flow" or nil (shows "+")
    let hasSpotting: Bool
    let symptomsPreview: String? // "Bloating, +2 more" or nil (shows "+")
}

struct CycleLogSection: View {
    let data: LogData
    let onPeriodTapped: () -> Void
    let onSpottingToggled: (Bool) -> Void
    let onSymptomsTapped: () -> Void

    @State private var periodPressed: Bool = false
    @State private var symptomsPressed: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            HStack {
                Text("Log")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Spacer()

                Text(data.selectedDate)
                    .font(AppTheme.Typography.bodySmall)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.bottom, AppTheme.Spacing.md)

            // Log rows
            VStack(spacing: 0) {
                // Period row
                LogRow(
                    label: "Period",
                    isPressed: periodPressed
                ) {
                    if let periodValue = data.periodValue {
                        Text(periodValue)
                            .font(AppTheme.Typography.bodyMedium.weight(.medium))
                            .foregroundColor(AppTheme.Colors.primaryAction)
                    } else {
                        Text("+")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.Colors.primaryAction)
                    }
                }
                .onTapGesture {
                    periodPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.quick) {
                        periodPressed = false
                    }
                    onPeriodTapped()
                }

                Divider()

                // Spotting row
                LogRow(
                    label: "Spotting",
                    isPressed: false
                ) {
                    CustomToggle(isOn: Binding(
                        get: { data.hasSpotting },
                        set: { onSpottingToggled($0) }
                    ))
                }

                Divider()

                // Symptoms row
                LogRow(
                    label: "Symptoms",
                    isPressed: symptomsPressed
                ) {
                    if let symptomsPreview = data.symptomsPreview {
                        Text(symptomsPreview)
                            .font(AppTheme.Typography.buttonSecondary)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    } else {
                        Text("+")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.Colors.primaryAction)
                    }
                }
                .onTapGesture {
                    symptomsPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.quick) {
                        symptomsPressed = false
                    }
                    onSymptomsTapped()
                }
            }
        }
        .padding(AppTheme.Spacing.xl)
        .background(Color.white)
    }
}

// MARK: - Log Row Component

struct LogRow<Content: View>: View {
    let label: String
    let isPressed: Bool
    let content: () -> Content

    var body: some View {
        HStack {
            Text(label)
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Spacer()

            content()
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(duration: AppTheme.Animation.quick), value: isPressed)
    }
}

// MARK: - Custom Toggle

struct CustomToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: AppTheme.Animation.quick)) {
                isOn.toggle()
            }
        }) {
            ZStack(alignment: isOn ? .trailing : .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 15)
                    .fill(isOn ? AppTheme.Colors.primaryAction : Color(hex: "D1D5D3"))
                    .frame(width: 50, height: 30)

                // Knob
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                    .padding(2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 24) {
        // Empty state
        CycleLogSection(
            data: LogData(
                selectedDate: "Wed, Jan 8",
                periodValue: nil,
                hasSpotting: false,
                symptomsPreview: nil
            ),
            onPeriodTapped: {
                print("Period tapped")
            },
            onSpottingToggled: { newValue in
                print("Spotting toggled to: \(newValue)")
            },
            onSymptomsTapped: {
                print("Symptoms tapped")
            }
        )

        // Filled state
        CycleLogSection(
            data: LogData(
                selectedDate: "Tue, Jan 7",
                periodValue: "Medium Flow",
                hasSpotting: true,
                symptomsPreview: "Bloating, +2 more"
            ),
            onPeriodTapped: {
                print("Period tapped")
            },
            onSpottingToggled: { newValue in
                print("Spotting toggled to: \(newValue)")
            },
            onSymptomsTapped: {
                print("Symptoms tapped")
            }
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}
