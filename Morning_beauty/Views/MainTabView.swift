import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("mainBG_1")
                .resizable()
                .ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .plan:
                    PlanView()
                case .care:
                    CareView()
                case .achievements:
                    AchievementsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
