import SwiftUI

struct FlowBarData {
    let flowLevel: FlowLevel? // nil = no data logged
    let hasSpotting: Bool
}

struct CycleFlowBar: View {
    let data: FlowBarData?

    private var barHeight: CGFloat {
        guard let flowLevel = data?.flowLevel else { return 0 }

        switch flowLevel {
        case .heavy:
            return 75
        case .medium:
            return 50
        case .light:
            return 25
        case .none, .unspecified:
            return 0
        }
    }

    private var barOpacity: Double {
        guard let flowLevel = data?.flowLevel else { return 0 }

        switch flowLevel {
        case .heavy:
            return 1.0
        case .medium:
            return 0.75
        case .light:
            return 0.5
        case .none, .unspecified:
            return 0
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Container with fixed height
            Color.clear
                .frame(height: 80)

            VStack(spacing: 0) {
                // Spotting indicator
                if data?.hasSpotting == true {
                    Circle()
                        .fill(AppTheme.Colors.accent)
                        .frame(width: 6, height: 6)
                        .offset(y: -6)
                } else {
                    Spacer()
                }

                // Flow bar
                if barHeight > 0 {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 4,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 4
                    )
                    .fill(AppTheme.Colors.primaryAction.opacity(barOpacity))
                    .frame(width: 24, height: barHeight)
                }
            }
            .frame(height: 80, alignment: .bottom)
        }
        .frame(height: 80)
    }
}

#Preview {
    HStack(spacing: 16) {
        VStack {
            CycleFlowBar(data: FlowBarData(flowLevel: .heavy, hasSpotting: true))
            Text("Heavy + Spotting")
                .font(AppTheme.Typography.caption)
        }

        VStack {
            CycleFlowBar(data: FlowBarData(flowLevel: .medium, hasSpotting: false))
            Text("Medium")
                .font(AppTheme.Typography.caption)
        }

        VStack {
            CycleFlowBar(data: FlowBarData(flowLevel: .light, hasSpotting: false))
            Text("Light")
                .font(AppTheme.Typography.caption)
        }

        VStack {
            CycleFlowBar(data: nil)
            Text("No Data")
                .font(AppTheme.Typography.caption)
        }
    }
    .padding()
}
