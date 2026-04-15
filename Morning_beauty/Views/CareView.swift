import SwiftUI

struct CareView: View {
    @StateObject private var viewModel = CareViewModel()

    var body: some View {
        ZStack {
            mainContent

            if viewModel.showAddCosmetic {
                AddCosmeticView(
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.showAddCosmetic = false
                        }
                    },
                    onCreated: { item in
                        viewModel.addItem(item)
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.showAddCosmetic = false
                        }
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.showAddCosmetic)
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            CareTopBarView()

            ZStack(alignment: .bottomTrailing) {
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
                            .padding(.bottom, screenHeight * 0.16)
                        }
                    }
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.showAddCosmetic = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: screenHeight * 0.028, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: screenHeight * 0.072, height: screenHeight * 0.072)
                        .background(Circle().fill(Color(red: 0.55, green: 0.48, blue: 0.78)))
                        .shadow(color: Color(red: 0.55, green: 0.48, blue: 0.78).opacity(0.45),
                                radius: screenHeight * 0.015, x: 0, y: screenHeight * 0.006)
                }
                .padding(.trailing, screenHeight * 0.028)
                .padding(.bottom, screenHeight * 0.12)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: screenHeight * 0.018) {
            Image(systemName: "sparkles")
                .font(.system(size: screenHeight * 0.06))
                .foregroundStyle(Color(red: 0.72, green: 0.65, blue: 0.85))

            Text("No products yet")
                .font(.app(screenHeight * 0.022, weight: .semiBold))
                .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.62))

            Text("Tap + to add your first cosmetic")
                .font(.app(screenHeight * 0.017))
                .foregroundStyle(Color(red: 0.62, green: 0.58, blue: 0.72))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.15)
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        CareView()
    }
}
