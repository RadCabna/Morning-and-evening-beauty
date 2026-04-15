import SwiftUI

final class LibraryViewModel: ObservableObject {
    private static let storageKey = "savedRituals"

    @Published var rituals: [RitualTemplate] {
        didSet { save() }
    }

    init() {
        self.rituals = LibraryViewModel.load() ?? LibraryViewModel.defaultRituals()
    }

    func onRitualTapped(_ ritual: RitualTemplate) {}

    private func save() {
        guard let data = try? JSONEncoder().encode(rituals) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private static func load() -> [RitualTemplate]? {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let rituals = try? JSONDecoder().decode([RitualTemplate].self, from: data),
            !rituals.isEmpty
        else { return nil }
        return rituals
    }

    static func defaultRituals() -> [RitualTemplate] {
        [
            RitualTemplate(
                id: UUID(), name: "Morning Care (Basic)", emoji: "🌅", timeOfDay: .morning,
                steps: [
                    RitualStep(id: UUID(), order: 1, title: "Cleansing", timing: 60, productCategory: "Gel / Foam / Micellar"),
                    RitualStep(id: UUID(), order: 2, title: "Toner", timing: 30, productCategory: "Toner / Essence"),
                    RitualStep(id: UUID(), order: 3, title: "Serum", timing: 60, productCategory: "Vitamin C / Hyaluronic"),
                    RitualStep(id: UUID(), order: 4, title: "Face Cream", timing: 60, productCategory: "Day Cream / Fluid"),
                    RitualStep(id: UUID(), order: 5, title: "SPF Protection", timing: 60, productCategory: "Sunscreen / SPF Cream")
                ], isDefault: true),
            RitualTemplate(
                id: UUID(), name: "Evening Care (Basic)", emoji: "🌙", timeOfDay: .evening,
                steps: [
                    RitualStep(id: UUID(), order: 1, title: "Makeup Removal", timing: 120, productCategory: "Micellar / Oil / Balm"),
                    RitualStep(id: UUID(), order: 2, title: "Cleansing", timing: 60, productCategory: "Gel / Foam / Scrub"),
                    RitualStep(id: UUID(), order: 3, title: "Toner / Essence", timing: 30, productCategory: "Hydrating / Soothing"),
                    RitualStep(id: UUID(), order: 4, title: "Night Cream", timing: 60, productCategory: "Nourishing / Restorative")
                ], isDefault: true),
            RitualTemplate(
                id: UUID(), name: "Date Ritual", emoji: "💕", timeOfDay: .specialCase,
                steps: [
                    RitualStep(id: UUID(), order: 1, title: "Cleansing", timing: 60, productCategory: "Gel / Foam"),
                    RitualStep(id: UUID(), order: 2, title: "Toner + Serum", timing: 90, productCategory: "Hydration + Glow"),
                    RitualStep(id: UUID(), order: 3, title: "Makeup Base", timing: 60, productCategory: "Primer / Base"),
                    RitualStep(id: UUID(), order: 4, title: "Foundation + Concealer", timing: 180, productCategory: "Foundation / Corrector"),
                    RitualStep(id: UUID(), order: 5, title: "Brow Styling", timing: 120, productCategory: "Gel / Pencil / Shadow"),
                    RitualStep(id: UUID(), order: 6, title: "Eye Makeup", timing: 240, productCategory: "Shadow / Liner / Mascara"),
                    RitualStep(id: UUID(), order: 7, title: "Lipstick + Setting", timing: 60, productCategory: "Lipstick / Setting Spray")
                ], isDefault: true),
            RitualTemplate(
                id: UUID(), name: "Spa Day", emoji: "🧖", timeOfDay: .specialCase,
                steps: [
                    RitualStep(id: UUID(), order: 1, title: "Makeup Removal + Cleansing", timing: 180, productCategory: "Two-Phase + Foam"),
                    RitualStep(id: UUID(), order: 2, title: "Peeling / Scrub", timing: 120, productCategory: "Enzyme / Mechanical"),
                    RitualStep(id: UUID(), order: 3, title: "Sheet Mask", timing: 900, productCategory: "Hydrating / Glow / Anti-Age"),
                    RitualStep(id: UUID(), order: 4, title: "Ampoule Serum", timing: 120, productCategory: "Concentrate / Booster"),
                    RitualStep(id: UUID(), order: 5, title: "Night Cream + Oil", timing: 120, productCategory: "Nourishing Cream + Face Oil"),
                    RitualStep(id: UUID(), order: 6, title: "Lip Care", timing: 60, productCategory: "Scrub + Balm"),
                    RitualStep(id: UUID(), order: 7, title: "Eye Area Care", timing: 60, productCategory: "Patches / Eye Cream"),
                    RitualStep(id: UUID(), order: 8, title: "Aromatherapy / Meditation", timing: 300, productCategory: "Candle / Diffuser / Music")
                ], isDefault: true)
        ]
    }
}
