import SwiftUI

struct InventoryOverlayView: View {
    let onDismiss: () -> Void

    @StateObject private var viewModel = CareViewModel()

    var body: some View {
        ZStack {
            Image("ritualBG")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        CosmeticFilterBarView(selectedCategory: $viewModel.selectedCategory)

                        if viewModel.filteredItems.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: screenHeight * 0.012) {
                                ForEach(viewModel.filteredItems) { item in
                                    CosmeticRowView(item: item)
                                }
                            }
                            .padding(.horizontal, screenHeight * 0.022)
                            .padding(.top, screenHeight * 0.008)
                            .padding(.bottom, screenHeight * 0.1)
                        }
                    }
                }
            }
        }
    }

    private var header: some View {
        ZStack {
            Text("Inventory")
                .font(.app(screenHeight * 0.024, weight: .semiBold))
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
            .padding(.horizontal, screenHeight * 0.022)
        }
        .frame(height: screenHeight * 0.06)
        .background(
            Color(red: 0.72, green: 0.65, blue: 0.82)
                .opacity(0.88)
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
    }

    private var emptyState: some View {
        VStack(spacing: screenHeight * 0.018) {
            Image(systemName: "sparkles")
                .font(.system(size: screenHeight * 0.06))
                .foregroundStyle(Color(red: 0.72, green: 0.65, blue: 0.85))

            Text("No products yet")
                .font(.app(screenHeight * 0.022, weight: .semiBold))
                .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.62))

            Text("Add products in the Care tab")
                .font(.app(screenHeight * 0.017))
                .foregroundStyle(Color(red: 0.62, green: 0.58, blue: 0.72))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.15)
    }
}

#Preview {
    InventoryOverlayView(onDismiss: {})
}
