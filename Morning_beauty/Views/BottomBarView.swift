import SwiftUI

struct BottomBarView: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Spacer()
                Button {
                    selectedTab = tab
                } label: {
                    Image(selectedTab == tab ? tab.iconOn : tab.iconOff)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenHeight * 0.055, height: screenHeight * 0.055)
                        .animation(.easeInOut(duration: 0.2), value: selectedTab)
                }
                Spacer()
            }
        }
        .frame(height: screenHeight * 0.085)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                .fill(Color.white.opacity(0.5))
        )
        .padding(.horizontal, screenHeight * 0.025)
        .padding(.bottom, screenHeight * 0.03)
        .shadow(color: .black.opacity(0.15), radius: screenHeight * 0.015, x: 0, y: screenHeight * 0.005)
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Color.gray.opacity(0.3).ignoresSafeArea()
        BottomBarView(selectedTab: .constant(.home))
    }
}
