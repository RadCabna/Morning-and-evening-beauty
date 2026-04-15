import SwiftUI

struct PlanView: View {
    var body: some View {
        LibraryView()
    }
}

#Preview {
    ZStack {
        Image("mainBG_1")
            .resizable()
            .ignoresSafeArea()
        PlanView()
    }
}
