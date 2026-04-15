import SwiftUI

struct LibraryTopBarView: View {
    var body: some View {
        ZStack {
            Text("Library")
                .font(.app(screenHeight * 0.028, weight: .semiBold))
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
}

#Preview {
    ZStack {
        Image("mainBG_1")
            .resizable()
            .ignoresSafeArea()
        VStack {
            LibraryTopBarView()
            Spacer()
        }
    }
}
