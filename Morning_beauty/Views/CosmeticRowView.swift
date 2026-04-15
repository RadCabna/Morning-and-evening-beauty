import SwiftUI

struct CosmeticRowView: View {
    let item: CosmeticItem

    var body: some View {
        HStack(spacing: screenHeight * 0.018) {
            thumbnailView
                .frame(width: screenHeight * 0.088, height: screenHeight * 0.088)
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous))

            VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                Text(item.name)
                    .font(.app(screenHeight * 0.02, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.25, green: 0.22, blue: 0.42))
                    .lineLimit(1)

                if !item.brandName.isEmpty {
                    Text(item.brandName)
                        .font(.app(screenHeight * 0.016))
                        .foregroundStyle(Color(red: 0.52, green: 0.48, blue: 0.65))
                        .lineLimit(1)
                }

                Spacer(minLength: screenHeight * 0.006)

                HStack {
                    if !item.volume.isEmpty {
                        Text(item.volume)
                            .font(.app(screenHeight * 0.015))
                            .foregroundStyle(Color(red: 0.65, green: 0.62, blue: 0.75))
                    }

                    Spacer()

                    if item.isOpened, let date = item.openedDate {
                        Text("Opened: \(date.formatted(.dateTime.day().month(.twoDigits).year()))")
                            .font(.app(screenHeight * 0.014))
                            .foregroundStyle(Color(red: 0.52, green: 0.48, blue: 0.65))
                    }
                }
            }
            .frame(maxHeight: screenHeight * 0.088)
        }
        .padding(.horizontal, screenHeight * 0.018)
        .padding(.vertical, screenHeight * 0.016)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .fill(.white.opacity(0.82))
        )
        .shadow(color: .black.opacity(0.07), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.003)
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let data = item.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                .fill(Color(red: 0.92, green: 0.9, blue: 0.96))
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: screenHeight * 0.032))
                        .foregroundStyle(Color(red: 0.72, green: 0.68, blue: 0.82))
                )
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        VStack(spacing: 10) {
            CosmeticRowView(item: CosmeticItem(
                id: UUID(), name: "Hyaluronic Serum", brandName: "The Ordinary",
                volume: "30 ml", category: .serums, imageData: nil,
                isOpened: true, openedDate: Date(), notes: ""
            ))
            CosmeticRowView(item: CosmeticItem(
                id: UUID(), name: "Morning Cleanser", brandName: "CeraVe",
                volume: "150 ml", category: .cleansing, imageData: nil,
                isOpened: false, openedDate: nil, notes: ""
            ))
        }
        .padding(.horizontal, 16)
    }
}
