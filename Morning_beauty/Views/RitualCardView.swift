import SwiftUI

struct RitualCardView: View {
    let template: RitualTemplate
    let session: RitualSession?
    let onStart: () -> Void

    private var completedCount: Int { session?.completedStepIndices.count ?? 0 }
    private var totalSteps: Int { template.steps.count }
    private var elapsed: Double { session?.elapsedSeconds ?? 0 }
    private var hasActiveSession: Bool { session != nil && !(session?.isFinished ?? true) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            cardBackground

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: screenHeight * 0.012) {
                    if template.timeOfDay == .specialCase {
                        Text(template.emoji)
                            .font(.system(size: screenHeight * 0.038))
                    } else {
                        Color.clear
                            .frame(width: screenHeight * 0.038, height: screenHeight * 0.038)
                    }

                    VStack(alignment: .leading, spacing: screenHeight * 0.003) {
                        Text(template.name)
                            .font(.app(screenHeight * 0.024, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.45, green: 0.52, blue: 0.78))
                            .lineLimit(1)
                        Text(template.totalDurationFormatted)
                            .font(.app(screenHeight * 0.015))
                            .foregroundStyle(Color(red: 0.55, green: 0.58, blue: 0.72))
                    }

                    Spacer()
                }
                .padding(.top, screenHeight * 0.022)
                .padding(.horizontal, screenHeight * 0.022)

                Spacer()

                VStack(spacing: screenHeight * 0.008) {
                    Text("Step \(completedCount) of \(totalSteps)")
                        .font(.app(screenHeight * 0.02, weight: .semiBold))
                        .foregroundStyle(.white)

                    Rectangle()
                        .fill(.white.opacity(0.55))
                        .frame(height: 1)
                        .padding(.horizontal, screenHeight * 0.015)

                    Text(timerString)
                        .font(.app(screenHeight * 0.022, weight: .semiBold))
                        .foregroundStyle(.white)

                    Button(action: onStart) {
                        Text(hasActiveSession ? "Continue" : "Start ritual")
                            .font(.app(screenHeight * 0.016, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.35, green: 0.3, blue: 0.2))
                            .padding(.horizontal, screenHeight * 0.028)
                            .padding(.vertical, screenHeight * 0.008)
                            .background(
                                Capsule()
                                    .fill(Color(red: 1.0, green: 0.96, blue: 0.8))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(red: 0.88, green: 0.78, blue: 0.5), lineWidth: 1)
                                    )
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, screenHeight * 0.014)
                .padding(.horizontal, screenHeight * 0.06)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                        .fill(.black.opacity(0.28))
                        .padding(.horizontal, screenHeight * 0.04)
                )
                .padding(.bottom, screenHeight * 0.018)
            }
        }
        .frame(height: screenHeight * 0.29)
    }

    @ViewBuilder
    private var cardBackground: some View {
        if template.timeOfDay == .specialCase {
            RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.85, green: 0.78, blue: 0.95), Color(red: 0.95, green: 0.85, blue: 0.78)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
        } else {
            Image(template.timeOfDay.menuFrameImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous))
        }
    }

    private var timerString: String {
        "\(formatTime(elapsed)) / \(formatTime(template.totalDuration))"
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    let sh = UIScreen.main.bounds.height
    let t = RitualTemplate(
        id: UUID(), name: "Morning Care", emoji: "🌅", timeOfDay: .morning,
        steps: [
            RitualStep(id: UUID(), order: 1, title: "Cleansing", timing: 60, productCategory: ""),
            RitualStep(id: UUID(), order: 2, title: "Toner", timing: 30, productCategory: "")
        ],
        isDefault: true)
    ZStack {
        Color.purple.opacity(0.3).ignoresSafeArea()
        RitualCardView(template: t, session: nil, onStart: {})
            .padding(.horizontal, 20)
    }
}
