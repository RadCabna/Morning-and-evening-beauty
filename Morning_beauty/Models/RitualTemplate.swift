import SwiftUI

struct RitualTemplate: Identifiable, Codable {
    let id: UUID
    var name: String
    var emoji: String
    var timeOfDay: TimeOfDay
    var steps: [RitualStep]
    var isDefault: Bool
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case id, name, emoji, timeOfDay, steps, isDefault, imageData
    }

    var totalDuration: TimeInterval {
        steps.reduce(0) { $0 + $1.timing }
    }

    var totalDurationFormatted: String {
        let total = Int(totalDuration)
        let minutes = total / 60
        return "\(minutes) min"
    }

    var badgeColor: Color {
        switch timeOfDay {
        case .morning: return Color(red: 1.0, green: 0.82, blue: 0.5)
        case .evening: return Color(red: 0.65, green: 0.6, blue: 0.88)
        case .specialCase: return Color(red: 0.95, green: 0.72, blue: 0.8)
        }
    }
}
