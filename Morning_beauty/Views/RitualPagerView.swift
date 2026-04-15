import SwiftUI

struct RitualPagerView: View {
    let rituals: [RitualTemplate]
    let sessions: [UUID: RitualSession]
    let onStart: (RitualTemplate) -> Void

    @State private var currentIndex: Int = 0

    var body: some View {
        VStack(spacing: screenHeight * 0.01) {
            if rituals.isEmpty {
                emptyCard
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(Array(rituals.enumerated()), id: \.element.id) { index, template in
                        RitualCardView(
                            template: template,
                            session: sessions[template.id],
                            onStart: { onStart(template) }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: screenHeight * 0.29)
            }

            HStack(spacing: screenHeight * 0.008) {
                ForEach(0..<max(rituals.count, 1), id: \.self) { i in
                    Circle()
                        .fill(i == currentIndex
                              ? Color(red: 0.52, green: 0.45, blue: 0.78)
                              : Color(red: 0.52, green: 0.45, blue: 0.78).opacity(0.3))
                        .frame(width: screenHeight * 0.009, height: screenHeight * 0.009)
                }
            }
            .frame(height: screenHeight * 0.018)
            .opacity(rituals.count > 1 ? 1 : 0)
        }
        .onChange(of: rituals.map(\.id)) { currentIndex = 0 }
    }

    private var emptyCard: some View {
        RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
            .fill(.white.opacity(0.55))
            .frame(height: screenHeight * 0.29)
            .overlay(
                VStack(spacing: screenHeight * 0.012) {
                    Text("No rituals yet")
                        .font(.app(screenHeight * 0.02, weight: .semiBold))
                        .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.62))
                    Text("Add one in the Library tab")
                        .font(.app(screenHeight * 0.016))
                        .foregroundStyle(Color(red: 0.6, green: 0.58, blue: 0.72))
                }
            )
    }
}
