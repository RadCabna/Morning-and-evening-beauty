import Foundation

enum TabItem: Int, CaseIterable {
    case home
    case plan
    case care
    case achievements

    var iconOn: String {
        switch self {
        case .home: return "menu_1On"
        case .plan: return "menu_2On"
        case .care: return "menu_3On"
        case .achievements: return "menu_4On"
        }
    }

    var iconOff: String {
        switch self {
        case .home: return "menu_1Off"
        case .plan: return "menu_2Off"
        case .care: return "menu_3Off"
        case .achievements: return "menu_4Off"
        }
    }
}
