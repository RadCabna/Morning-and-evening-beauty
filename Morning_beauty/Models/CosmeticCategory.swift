import Foundation

enum CosmeticCategory: String, Codable, CaseIterable, Identifiable {
    case cleansing = "cleansing"
    case toners    = "toners"
    case serums    = "serums"
    case creams    = "creams"
    case spf       = "spf"
    case makeup    = "makeup"
    case masks     = "masks"
    case special   = "special"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cleansing: return "Cleansing"
        case .toners:    return "Toners / Essences"
        case .serums:    return "Serums / Ampoules"
        case .creams:    return "Creams / Hydration"
        case .spf:       return "SPF / Protection"
        case .makeup:    return "Makeup"
        case .masks:     return "Masks / Peeling"
        case .special:   return "Special Care"
        }
    }
}
