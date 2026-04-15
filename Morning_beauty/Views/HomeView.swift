import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showStats = false

    var body: some View {
        ZStack {
            mainContent

            if showStats {
                StatsView(onDismiss: {
                    withAnimation(.easeInOut(duration: 0.25)) { showStats = false }
                })
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            if let template = viewModel.selectedTemplateForExecution {
                RitualExecutionView(
                    template: template,
                    session: viewModel.session(for: template),
                    onDismiss: {
                        viewModel.refreshSessions()
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.selectedTemplateForExecution = nil
                        }
                    }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showStats)
        .animation(.easeInOut(duration: 0.25), value: viewModel.selectedTemplateForExecution?.id)
        .onAppear { viewModel.loadData() }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            HomeTopBarView(onStatsTapped: {
                withAnimation(.easeInOut(duration: 0.25)) { showStats = true }
            })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    FilterBarView(selectedFilter: $viewModel.selectedFilter)
                        .padding(.bottom, screenHeight * 0.02)

                    RitualPagerView(
                        rituals: viewModel.filteredTemplates,
                        sessions: viewModel.sessions,
                        onStart: { viewModel.startRitual($0) }
                    )
                    .shadow(color: .black.opacity(0.18), radius: screenHeight * 0.015, x: 0, y: screenHeight * 0.006)
                    .padding(.bottom, screenHeight * 0.032)

                    QuickAccessRowView(
                        templates: viewModel.quickAccessTemplates,
                        sessions: viewModel.sessions,
                        onTap: { viewModel.startRitual($0) }
                    )
                    .padding(.bottom, screenHeight * 0.05)

                    StreakBannerView(days: viewModel.streakDays)
                        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.004)
                }
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.top, screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.16)
            }
        }
    }

}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        HomeView()
    }
}
