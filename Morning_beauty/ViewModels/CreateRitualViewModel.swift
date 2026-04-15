import SwiftUI
import UIKit

struct StepEntry: Identifiable {
    let id: UUID = UUID()
    var title: String = ""
    var durationMinutes: Int = 5
}

final class CreateRitualViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedIconName: String? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var steps: [StepEntry] = [StepEntry()]
    @Published var reminderHour: Int = 7
    @Published var reminderMinute: Int = 0
    @Published var isAM: Bool = true
    @Published var showIconPicker: Bool = false
    @Published var showTimePicker: Bool = false
    @Published var showImageSourceDialog: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    let iconNames: [String] = (1...30).map { "riteIcon_\($0)" }

    var resolvedTimeOfDay: TimeOfDay {
        let h24: Int
        if isAM {
            h24 = reminderHour == 12 ? 0 : reminderHour
        } else {
            h24 = reminderHour == 12 ? 12 : reminderHour + 12
        }
        switch h24 {
        case 5...11:  return .morning
        case 17...23: return .evening
        default:      return .specialCase
        }
    }

    var reminderTimeFormatted: String {
        let h = reminderHour == 0 ? 12 : reminderHour
        let m = String(format: "%02d", reminderMinute)
        return "\(h):\(m) \(isAM ? "AM" : "PM")"
    }

    func addStep() {
        steps.append(StepEntry())
    }

    func removeStep(at index: Int) {
        guard steps.count > 1 else { return }
        steps.remove(at: index)
    }

    func onCreateTapped(completion: (RitualTemplate) -> Void) {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.7)
        let template = RitualTemplate(
            id: UUID(),
            name: name.isEmpty ? "New Ritual" : name,
            emoji: selectedIconName ?? "riteIcon_1",
            timeOfDay: resolvedTimeOfDay,
            steps: steps.enumerated().map { i, entry in
                RitualStep(
                    id: UUID(),
                    order: i + 1,
                    title: entry.title.isEmpty ? "Step \(i + 1)" : entry.title,
                    timing: TimeInterval(entry.durationMinutes * 60),
                    productCategory: ""
                )
            },
            isDefault: false,
            imageData: imageData
        )
        completion(template)
    }
}
