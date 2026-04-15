import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    let onDismiss: () -> Void

    private let purple = Color(red: 0.42, green: 0.35, blue: 0.72)
    private let cardBg = Color.white.opacity(0.82)

    var body: some View {
        ZStack {
            Image("mainBG_1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: screenHeight * 0.024) {
                        periodPicker
                        summaryCard
                        barSection
                        pieSection
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.022)
                    .padding(.bottom, screenHeight * 0.12)
                }
            }
        }
    }

    private var header: some View {
        ZStack {
            Text("Statistics")
                .font(.app(screenHeight * 0.026, weight: .semiBold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: screenHeight * 0.022, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
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

    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedPeriod = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.app(screenHeight * 0.018, weight: .semiBold))
                        .foregroundStyle(viewModel.selectedPeriod == period ? .white : purple)
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight * 0.044)
                        .background(
                            Capsule()
                                .fill(viewModel.selectedPeriod == period
                                      ? Color(red: 0.62, green: 0.55, blue: 0.82)
                                      : Color(red: 1.0, green: 0.92, blue: 0.72))
                        )
                }
            }
        }
        .padding(screenHeight * 0.006)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.5))
        )
        .frame(width: screenHeight * 0.28)
    }

    private var summaryCard: some View {
        VStack(spacing: 0) {
            summaryRow(emoji: "📖", title: "Rituals:", value: "\(viewModel.totalRituals)")
            Divider().padding(.leading, screenHeight * 0.065)
            summaryRow(emoji: "🏆", title: "Average Time:", value: viewModel.averageTime)
            Divider().padding(.leading, screenHeight * 0.065)
            summaryRow(emoji: "💛", title: "Favorite Category:", value: viewModel.favoriteCategory)
        }
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .fill(cardBg)
        )
        .shadow(color: .black.opacity(0.08), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.004)
    }

    private func summaryRow(emoji: String, title: String, value: String) -> some View {
        HStack(spacing: screenHeight * 0.016) {
            Text(emoji)
                .font(.system(size: screenHeight * 0.032))
                .frame(width: screenHeight * 0.044)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(title) ")
                    .font(.app(screenHeight * 0.018, weight: .semiBold))
                    .foregroundStyle(purple)
                +
                Text(value)
                    .font(.app(screenHeight * 0.018, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.25, green: 0.55, blue: 0.82))
            }
            Spacer()
        }
        .padding(.horizontal, screenHeight * 0.022)
        .frame(height: screenHeight * 0.068)
    }

    private var barSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            BarChartView(
                entries: viewModel.barData,
                yAxisLabel: "Rituals:"
            )
            .frame(height: screenHeight * 0.24)
            .animation(.easeInOut(duration: 0.3), value: viewModel.selectedPeriod)
        }
        .padding(.horizontal, screenHeight * 0.01)
        .padding(.vertical, screenHeight * 0.016)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .fill(cardBg)
        )
        .shadow(color: .black.opacity(0.08), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.004)
    }

    private var pieSection: some View {
        PieChartView(slices: viewModel.pieData)
            .frame(width: screenHeight * 0.26, height: screenHeight * 0.26)
            .frame(maxWidth: .infinity)
            .padding(.vertical, screenHeight * 0.01)
    }
}

#Preview {
    StatsView(onDismiss: {})
}
