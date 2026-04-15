import SwiftUI

struct FilterBarView: View {
    @Binding var selectedFilter: TimeOfDay

    var body: some View {
        HStack(spacing: screenHeight * 0.012) {
            ForEach(TimeOfDay.allCases, id: \.self) { filter in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = filter
                    }
                } label: {
                    Text(filter.title)
                        .font(.app(screenHeight * 0.018, weight: .semiBold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight * 0.048)
                        .background(
                            Image(selectedFilter == filter ? "filterFrameOn" : "filterFrameOff")
                                .resizable()
                        )
                        .shadow(color: .black.opacity(0.15), radius: screenHeight * 0.008, x: 0, y: screenHeight * 0.003)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.purple.opacity(0.4).ignoresSafeArea()
        FilterBarView(selectedFilter: .constant(.morning))
            .padding(.horizontal, 20)
    }
}
