import Foundation

struct RitualSession: Identifiable, Codable {
    let id: UUID
    let templateId: UUID
    var completedStepIndices: [Int]
    var elapsedSeconds: Double
    var isFinished: Bool
    var lastActiveAt: Date

    init(templateId: UUID) {
        self.id = UUID()
        self.templateId = templateId
        self.completedStepIndices = []
        self.elapsedSeconds = 0
        self.isFinished = false
        self.lastActiveAt = Date()
    }
}
