import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var selectedFilter: TimeOfDay = .morning
    @Published var templates: [RitualTemplate] = []
    @Published var sessions: [UUID: RitualSession] = [:]
    @Published var streakDays: Int = 0
    @Published var selectedTemplateForExecution: RitualTemplate? = nil


    var filteredTemplates: [RitualTemplate] {
        templates.filter { $0.timeOfDay == selectedFilter }
    }

    var quickAccessTemplates: [RitualTemplate] {
        Array(filteredTemplates.prefix(3))
    }

    func session(for template: RitualTemplate) -> RitualSession? {
        sessions[template.id]
    }

    func startRitual(_ template: RitualTemplate) {
        selectedTemplateForExecution = template
    }

    func loadData() {
        RitualSessionStore.shared.clearUnfinishedIfNewDay()
        templates = loadTemplates()
        streakDays = computeStreak()
        refreshSessions()
    }

    func refreshSessions() {
        var dict: [UUID: RitualSession] = [:]
        for s in RitualSessionStore.shared.all where !s.isFinished {
            dict[s.templateId] = s
        }
        sessions = dict
    }

    func onStatsTapped() {}

    private func loadTemplates() -> [RitualTemplate] {
        if let data = UserDefaults.standard.data(forKey: "savedRituals"),
           let loaded = try? JSONDecoder().decode([RitualTemplate].self, from: data),
           !loaded.isEmpty {
            return loaded
        }
        let defaults = LibraryViewModel.defaultRituals()
        if let data = try? JSONEncoder().encode(defaults) {
            UserDefaults.standard.set(data, forKey: "savedRituals")
        }
        return defaults
    }

    private func computeStreak() -> Int {
        let cal = Calendar.current
        let days = Set(CompletionStore.shared.all.map { cal.startOfDay(for: $0.completedAt) })
        var streak = 0
        var check = cal.startOfDay(for: Date())
        while days.contains(check) {
            streak += 1
            check = cal.date(byAdding: .day, value: -1, to: check)!
        }
        return streak
    }
}
