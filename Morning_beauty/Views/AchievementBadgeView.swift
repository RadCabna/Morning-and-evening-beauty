import SwiftUI

struct AchievementBadgeView: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: screenHeight * 0.005) {
            Image(achievement.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.058, height: screenHeight * 0.058)
                .opacity(achievement.isUnlocked ? 1.0 : 0.35)

            Text(achievement.name)
                .font(.app(screenHeight * 0.011))
                .foregroundStyle(
                    achievement.isUnlocked
                        ? Color(red: 0.35, green: 0.3, blue: 0.55)
                        : Color(red: 0.55, green: 0.52, blue: 0.68)
                )
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, screenHeight * 0.006)
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        HStack(spacing: 16) {
            AchievementBadgeView(achievement: Achievement(
                id: 1, name: "7 Days Streak", iconName: "achIcon_1",
                category: .consistency, isUnlocked: true))
            AchievementBadgeView(achievement: Achievement(
                id: 2, name: "14 Days Streak", iconName: "achIcon_2",
                category: .consistency, isUnlocked: false))
        }
    }
}
