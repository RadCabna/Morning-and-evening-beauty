import SwiftUI

struct QuickAccessCardView: View {
    let template: RitualTemplate
    let session: RitualSession?
    let onTap: () -> Void

    private let labelHeight: CGFloat = 0.072

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                cardBackground
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: screenHeight * (0.155 - labelHeight))
                    .clipped()

                VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                    Text(template.name)
                        .font(.app(screenHeight * 0.015, weight: .semiBold))
                        .foregroundStyle(Color(red: 0.25, green: 0.22, blue: 0.35))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)

                    if let session {
                        Text("\(session.completedStepIndices.count)/\(template.steps.count) steps")
                            .font(.app(screenHeight * 0.012))
                            .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.62))
                    } else {
                        Text(template.totalDurationFormatted)
                            .font(.app(screenHeight * 0.012))
                            .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.68))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: screenHeight * labelHeight, alignment: .topLeading)
                .padding(.horizontal, screenHeight * 0.012)
                .padding(.vertical, screenHeight * 0.009)
                .background(Color.white)
            }
            .frame(height: screenHeight * 0.155)
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous))
            .shadow(color: .black.opacity(0.14), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
        }
    }

    @ViewBuilder
    private var cardBackground: some View {
        if let data = template.imageData, let uiImg = UIImage(data: data) {
            Image(uiImage: uiImg)
                .resizable()
                .scaledToFill()
        } else if template.timeOfDay == .specialCase {
            LinearGradient(
                colors: [Color(red: 0.85, green: 0.78, blue: 0.95), Color(red: 0.95, green: 0.85, blue: 0.78)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        } else {
            Image(template.timeOfDay.menuFrameImage)
                .resizable()
                .scaledToFill()
        }
    }
}

struct QuickAccessRowView: View {
    let templates: [RitualTemplate]
    let sessions: [UUID: RitualSession]
    let onTap: (RitualTemplate) -> Void

    private var cardWidth: CGFloat {
        let outerPadding = screenHeight * 0.022 * 2   // ScrollView horizontal padding (both sides)
        let gap = screenHeight * 0.012
        return (screenWidth - outerPadding - gap * 2) / 3
    }

    var body: some View {
        HStack(spacing: screenHeight * 0.012) {
            ForEach(templates) { template in
                QuickAccessCardView(
                    template: template,
                    session: sessions[template.id],
                    onTap: { onTap(template) }
                )
                .frame(width: cardWidth)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let t1 = RitualTemplate(id: UUID(), name: "Morning Care (Basic)", emoji: "🌅", timeOfDay: .morning,
                             steps: [RitualStep(id: UUID(), order: 1, title: "Cleansing", timing: 60, productCategory: "")],
                             isDefault: true)
    let t2 = RitualTemplate(id: UUID(), name: "Ритуал", emoji: "🌅", timeOfDay: .morning,
                             steps: [RitualStep(id: UUID(), order: 1, title: "Toner", timing: 60, productCategory: "")],
                             isDefault: true)
    ZStack {
        Color.purple.opacity(0.3).ignoresSafeArea()
        QuickAccessRowView(templates: [t1, t2], sessions: [:], onTap: { _ in })
            .padding(.horizontal, 20)
    }
}
