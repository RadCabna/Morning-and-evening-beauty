import Foundation

enum TimeOfDay: String, Codable, CaseIterable {
    case morning, evening, specialCase

    var title: String {
        switch self {
        case .morning: return "Morning"
        case .evening: return "Evening"
        case .specialCase: return "Special Case"
        }
    }

    var displayName: String { title }

    var menuFrameImage: String {
        switch self {
        case .morning: return "morningMenuFrame"
        case .evening: return "eveningMenuFrame"
        case .specialCase: return "morningMenuFrame"
        }
    }
}
