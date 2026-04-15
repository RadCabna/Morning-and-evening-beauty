import Foundation

struct RitualStep: Identifiable, Codable {
    let id: UUID
    var order: Int
    var title: String
    var timing: TimeInterval
    var productCategory: String

    var timingFormatted: String {
        let total = Int(timing)
        let minutes = total / 60
        let seconds = total % 60
        if minutes == 0 {
            return "\(seconds) sec"
        } else if seconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes) min \(seconds) sec"
        }
    }
}
