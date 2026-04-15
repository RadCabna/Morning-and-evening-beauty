import SwiftUI

struct CosmeticFilterBarView: View {
    @Binding var selectedCategory: CosmeticCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: screenHeight * 0.012) {
                filterButton(title: "All", isSelected: selectedCategory == nil) {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedCategory = nil }
                }
                ForEach(CosmeticCategory.allCases) { category in
                    filterButton(title: category.title, isSelected: selectedCategory == category) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal, screenHeight * 0.022)
            .padding(.vertical, screenHeight * 0.012)
        }
        .simultaneousGesture(DragGesture(minimumDistance: 0))
    }

    private func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.app(screenHeight * 0.016, weight: .semiBold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(width: screenHeight * 0.165, height: screenHeight * 0.048)
                .background(
                    Image(isSelected ? "filterFrameOn" : "filterFrameOff")
                        .resizable()
                )
                .shadow(color: .black.opacity(0.15), radius: screenHeight * 0.008, x: 0, y: screenHeight * 0.003)
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        VStack {
            CosmeticFilterBarView(selectedCategory: .constant(.cleansing))
            Spacer()
        }
    }
}
