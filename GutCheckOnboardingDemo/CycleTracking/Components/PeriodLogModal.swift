import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct PeriodLogModal: View {
    @Environment(\.dismiss) private var dismiss

    let date: String // "Wednesday, Jan 8"
    let initialFlow: FlowLevel? // Current value or nil
    let initialTracking: Bool // Whether currently tracking period
    let onSave: (Bool, FlowLevel?) -> Void // (isTracking, flowLevel)

    @State private var isTrackingPeriod: Bool
    @State private var selectedFlow: FlowLevel

    init(
        date: String,
        initialFlow: FlowLevel?,
        initialTracking: Bool,
        onSave: @escaping (Bool, FlowLevel?) -> Void
    ) {
        self.date = date
        self.initialFlow = initialFlow
        self.initialTracking = initialTracking
        self.onSave = onSave

        // Initialize state
        self._isTrackingPeriod = State(initialValue: initialTracking)
        self._selectedFlow = State(initialValue: initialFlow ?? .light)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                contentBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Date subtitle
                        Text(date)
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, AppTheme.Spacing.sm)
                            .padding(.bottom, AppTheme.Spacing.md)

                        // Toggle Section
                        HStack {
                            Text("Tracking Period")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.textPrimary)

                            Spacer()

                            Toggle("", isOn: $isTrackingPeriod)
                                .labelsHidden()
                                .tint(AppTheme.Colors.primaryAction)
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(Color.white)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.md)

                        // Flow Level Section (only shown when tracking)
                        if isTrackingPeriod {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text("FLOW LEVEL")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                    .padding(.horizontal, AppTheme.Spacing.md)

                                VStack(spacing: 0) {
                                    ForEach([FlowLevel.none, .light, .medium, .heavy], id: \.self) { level in
                                        Button(action: {
                                            selectedFlow = level
                                        }) {
                                            HStack {
                                                Text(level.rawValue)
                                                    .font(AppTheme.Typography.body)
                                                    .foregroundColor(AppTheme.Colors.textPrimary)

                                                Spacer()

                                                if selectedFlow == level {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 20, weight: .bold))
                                                        .foregroundColor(AppTheme.Colors.primaryAction)
                                                }
                                            }
                                            .padding(AppTheme.Spacing.md)
                                            .background(Color.white)
                                        }
                                        .buttonStyle(PlainButtonStyle())

                                        if level != .heavy {
                                            Divider()
                                                .padding(.leading, AppTheme.Spacing.md)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(AppTheme.CornerRadius.medium)
                                .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Period")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if isTrackingPeriod {
                            onSave(true, selectedFlow)
                        } else {
                            onSave(false, nil)
                        }
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primaryAction)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    PeriodLogModal(
        date: "Wednesday, Jan 8",
        initialFlow: .medium,
        initialTracking: true,
        onSave: { isTracking, flow in
            print("Tracking: \(isTracking), Flow: \(String(describing: flow))")
        }
    )
}
