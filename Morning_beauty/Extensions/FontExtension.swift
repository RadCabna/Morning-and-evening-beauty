import SwiftUI

extension Font {
    static func app(_ size: CGFloat, weight: AppFontWeight = .regular) -> Font {
        .custom(weight.fontName, size: size)
    }
}

enum AppFontWeight {
    case regular, semiBold

    var fontName: String {
        switch self {
        case .regular: return "BalooBhaijaan2-Regular"
        case .semiBold: return "BalooBhaijaan2-SemiBold"
        }
    }
}
