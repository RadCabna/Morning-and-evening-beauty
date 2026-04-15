import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    progressRow
                        .padding(.horizontal, screenHeight * 0.022)
                        .padding(.top, screenHeight * 0.018)
                        .padding(.bottom, screenHeight * 0.008)

                    ForEach(AchievementCategory.allCases, id: \.rawValue) { category in
                        let items = viewModel.achievements.filter { $0.category == category }
                        sectionView(title: category.rawValue, items: items)
                    }
                }
                .padding(.bottom, screenHeight * 0.14)
            }
        }
        .onAppear { viewModel.refresh() }
    }

    private var header: some View {
        ZStack {
            Text("Achievements")
                .font(.app(screenHeight * 0.026, weight: .semiBold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, screenHeight * 0.022)
        .frame(height: screenHeight * 0.06)
        .background(
            Color(red: 0.72, green: 0.65, blue: 0.82)
                .opacity(0.88)
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
    }

    private var progressRow: some View {
        Text("Progress: \(viewModel.unlockedCount)/\(viewModel.totalCount)")
            .font(.app(screenHeight * 0.022, weight: .semiBold))
            .foregroundStyle(Color(red: 0.35, green: 0.28, blue: 0.55))
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)

    private func sectionView(title: String, items: [Achievement]) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
            Text("\(title):")
                .font(.app(screenHeight * 0.02, weight: .semiBold))
                .foregroundStyle(Color(red: 0.3, green: 0.25, blue: 0.5))
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.top, screenHeight * 0.016)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(items) { achievement in
                    AchievementBadgeView(achievement: achievement)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, screenHeight * 0.018)
            .padding(.bottom, screenHeight * 0.006)
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        AchievementsView()
    }
}
