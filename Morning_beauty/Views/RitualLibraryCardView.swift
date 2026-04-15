import SwiftUI

struct RitualLibraryRowView: View {
    let ritual: RitualTemplate
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: screenHeight * 0.016) {
                Group {
                    if ritual.emoji.hasPrefix("riteIcon_") {
                        Image(ritual.emoji)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text(ritual.emoji)
                            .font(.system(size: screenHeight * 0.034))
                    }
                }
                .frame(width: screenHeight * 0.048, height: screenHeight * 0.048)

                Text(ritual.name)
                    .font(.app(screenHeight * 0.02, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.38, green: 0.35, blue: 0.58))
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: screenHeight * 0.016, weight: .medium))
                    .foregroundStyle(Color(red: 0.65, green: 0.62, blue: 0.75))
            }
            .padding(.horizontal, screenHeight * 0.02)
            .frame(height: screenHeight * 0.068)
        }
    }
}

#Preview {
    let sh = UIScreen.main.bounds.height
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        VStack(spacing: 0) {
            RitualLibraryRowView(
                ritual: RitualTemplate(id: UUID(), name: "Morning Care", emoji: "☀️", timeOfDay: .morning, steps: [], isDefault: true),
                onTap: {}
            )
            Divider()
            RitualLibraryRowView(
                ritual: RitualTemplate(id: UUID(), name: "Evening Care", emoji: "🌙", timeOfDay: .evening, steps: [], isDefault: true),
                onTap: {}
            )
        }
        .background(RoundedRectangle(cornerRadius: sh * 0.025).fill(.white.opacity(0.82)))
        .padding(.horizontal, 20)
    }
}
