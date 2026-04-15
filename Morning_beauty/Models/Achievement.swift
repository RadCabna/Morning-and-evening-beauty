import Foundation

enum AchievementCategory: String, CaseIterable {
    case consistency  = "Consistency"
    case experiments  = "Experiments"
    case speed        = "Speed"
    case collector    = "Collector"
    case master       = "Master"
}

struct Achievement: Identifiable {
    let id: Int
    let name: String
    let iconName: String
    let category: AchievementCategory
    var isUnlocked: Bool = false
}
