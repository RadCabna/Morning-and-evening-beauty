import SwiftUI
import UIKit

final class AddCosmeticViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var brandName: String = ""
    @Published var volume: String = ""
    @Published var selectedCategory: CosmeticCategory = .cleansing
    @Published var selectedImage: UIImage? = nil
    @Published var isOpened: Bool = false
    @Published var openedDate: Date = Date()
    @Published var notes: String = ""

    @Published var showImageSourceDialog: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showDatePicker: Bool = false

    func buildItem() -> CosmeticItem {
        CosmeticItem(
            id: UUID(),
            name: name.isEmpty ? "New Cosmetic" : name,
            brandName: brandName,
            volume: volume,
            category: selectedCategory,
            imageData: selectedImage?.jpegData(compressionQuality: 0.7),
            isOpened: isOpened,
            openedDate: isOpened ? openedDate : nil,
            notes: notes
        )
    }
}
