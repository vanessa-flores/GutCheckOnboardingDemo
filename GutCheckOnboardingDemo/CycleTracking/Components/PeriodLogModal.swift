import SwiftUI

// Very light warm background for content
private let contentBackground = Color(hex: "FBFAF9")

struct PeriodLogModal: View {
    @Environment(\.dismiss) private var dismiss

    let date: String // "Wednesday, Jan 8"
    let initialFlow: FlowLevel? // Current value or nil
    let onSave: (Bool, FlowLevel?) -> Void // (isTracking, flowLevel)

    @State private var hadFlow: Bool?  // nil = not selected, true = yes, false = no
    @State private var selectedFlowLevel: FlowLevel?  // nil = not selected

    init(
        date: String,
        initialFlow: FlowLevel?,
        onSave: @escaping (Bool, FlowLevel?) -> Void
    ) {
        self.date = date
        self.initialFlow = initialFlow
        self.onSave = onSave

        // Initialize state based on initial flow
        if let initialFlow = initialFlow {
            if initialFlow == .none {
                // Was tracking period with no flow
                self._hadFlow = State(initialValue: false)
                self._selectedFlowLevel = State(initialValue: nil)
            } else {
                // Was tracking period with flow
                self._hadFlow = State(initialValue: true)
                self._selectedFlowLevel = State(initialValue: initialFlow)
            }
        } else {
            // Not tracking period
            self._hadFlow = State(initialValue: nil)
            self._selectedFlowLevel = State(initialValue: nil)
        }
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

                        // SECTION 1: Did you have flow today?
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("DID YOU HAVE FLOW TODAY?")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .padding(.horizontal, AppTheme.Spacing.md)

                            VStack(spacing: 0) {
                                // Yes option
                                Button(action: {
                                    handleFlowPresenceSelection(true)
                                }) {
                                    HStack {
                                        Text("Yes")
                                            .font(AppTheme.Typography.body)
                                            .foregroundColor(AppTheme.Colors.textPrimary)

                                        Spacer()

                                        if hadFlow == true {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(AppTheme.Colors.primaryAction)
                                        }
                                    }
                                    .padding(AppTheme.Spacing.md)
                                    .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Divider()
                                    .padding(.leading, AppTheme.Spacing.md)

                                // No option
                                Button(action: {
                                    handleFlowPresenceSelection(false)
                                }) {
                                    HStack {
                                        Text("No")
                                            .font(AppTheme.Typography.body)
                                            .foregroundColor(AppTheme.Colors.textPrimary)

                                        Spacer()

                                        if hadFlow == false {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(AppTheme.Colors.primaryAction)
                                        }
                                    }
                                    .padding(AppTheme.Spacing.md)
                                    .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .background(Color.white)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }
                        .padding(.bottom, AppTheme.Spacing.md)

                        // SECTION 2: Flow Level
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("FLOW LEVEL")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .padding(.horizontal, AppTheme.Spacing.md)

                            VStack(spacing: 0) {
                                ForEach([FlowLevel.light, .medium, .heavy], id: \.self) { level in
                                    Button(action: {
                                        handleFlowLevelSelection(level)
                                    }) {
                                        HStack {
                                            Text(level.rawValue)
                                                .font(AppTheme.Typography.body)
                                                .foregroundColor(AppTheme.Colors.textPrimary)

                                            Spacer()

                                            if selectedFlowLevel == level {
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
                        if hadFlow == true {
                            // "Yes" selected - save with flow level if specified, otherwise .none
                            let flowLevel = selectedFlowLevel ?? .none
                            onSave(true, flowLevel)
                        } else if hadFlow == false {
                            // "No" selected (period but no flow)
                            onSave(true, .none)
                        } else {
                            // Nothing selected - don't save
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

    // MARK: - Helper Methods

    /// Handles "Yes" or "No" selection in flow presence section
    /// - "Yes" selected: Sets hadFlow to true, keeps any existing flow level
    /// - "No" selected: Sets hadFlow to false, clears any flow level
    private func handleFlowPresenceSelection(_ hasFlow: Bool) {
        if hasFlow {
            // User tapped "Yes"
            hadFlow = true
            // Don't change selectedFlowLevel - let them choose
        } else {
            // User tapped "No" (period but no flow)
            hadFlow = false
            selectedFlowLevel = nil  // Clear any flow level selection
        }
    }

    /// Handles flow level selection (Light/Medium/Heavy)
    /// Automatically sets "Yes" in flow presence section
    private func handleFlowLevelSelection(_ level: FlowLevel) {
        selectedFlowLevel = level
        hadFlow = true  // Automatically select "Yes"
    }
}

#Preview {
    PeriodLogModal(
        date: "Wednesday, Jan 8",
        initialFlow: .medium,
        onSave: { isTracking, flow in
            print("Tracking: \(isTracking), Flow: \(String(describing: flow))")
        }
    )
}
