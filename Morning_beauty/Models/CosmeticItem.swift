import Foundation

struct CosmeticItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var brandName: String
    var volume: String
    var category: CosmeticCategory
    var imageData: Data?
    var isOpened: Bool
    var openedDate: Date?
    var notes: String
}
