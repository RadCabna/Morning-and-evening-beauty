import Foundation

struct RitualCompletion: Identifiable, Codable {
    let id: UUID
    let ritualName: String
    let timeOfDay: TimeOfDay
    let completedAt: Date
}
