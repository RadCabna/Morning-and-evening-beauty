import SwiftUI

struct StreakBannerView: View {
    let days: Int

    var body: some View {
        HStack(spacing: screenHeight * 0.014) {
            Text("🔥")
                .font(.system(size: screenHeight * 0.028))
            Text("\(days) days in a row with rituals")
                .font(.app(screenHeight * 0.02, weight: .semiBold))
                .foregroundStyle(Color(red: 0.3, green: 0.25, blue: 0.15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, screenHeight * 0.025)
        .frame(height: screenHeight * 0.072)
        .background(
            Capsule()
                .fill(.white.opacity(0.7))
        )
    }
}

#Preview {
    ZStack {
        Color.orange.opacity(0.3).ignoresSafeArea()
        StreakBannerView(days: 5)
            .padding(.horizontal, 20)
    }
}
