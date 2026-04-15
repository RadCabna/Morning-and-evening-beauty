import Foundation

struct Ritual: Identifiable {
    let id: UUID
    var name: String
    var emoji: String
    var totalSteps: Int
    var currentStep: Int
    var elapsed: TimeInterval
    var duration: TimeInterval
    var imageName: String
    var timeOfDay: TimeOfDay
}
