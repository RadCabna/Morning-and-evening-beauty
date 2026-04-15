import SwiftUI

struct IconPickerOverlayView: View {
    let iconNames: [String]
    @Binding var selectedIconName: String?
    let onDismiss: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                Text("Select icon")
                    .font(.app(screenHeight * 0.02, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.35, green: 0.3, blue: 0.5))
                    .padding(.top, screenHeight * 0.022)
                    .padding(.bottom, screenHeight * 0.014)

                LazyVGrid(columns: columns, spacing: screenHeight * 0.008) {
                    ForEach(iconNames, id: \.self) { name in
                        Button {
                            selectedIconName = name
                            onDismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(
                                        selectedIconName == name
                                            ? Color(red: 0.3, green: 0.7, blue: 0.65)
                                            : Color(red: 0.3, green: 0.7, blue: 0.65).opacity(0.35),
                                        lineWidth: selectedIconName == name ? 2.5 : 1.5
                                    )
                                    .frame(width: screenHeight * 0.066, height: screenHeight * 0.066)

                                Image(name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenHeight * 0.046, height: screenHeight * 0.046)
                            }
                        }
                    }
                }
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.022)
            }
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                    .fill(.white.opacity(0.97))
            )
            .padding(.horizontal, screenHeight * 0.04)
            .shadow(color: .black.opacity(0.2), radius: screenHeight * 0.02, x: 0, y: screenHeight * 0.008)
        }
    }
}

#Preview {
    let sh = UIScreen.main.bounds.height
    let _ = sh
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        IconPickerOverlayView(
            iconNames: (1...30).map { "riteIcon_\($0)" },
            selectedIconName: .constant("riteIcon_1"),
            onDismiss: {}
        )
    }
}
