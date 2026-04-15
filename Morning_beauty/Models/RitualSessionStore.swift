import Foundation

final class RitualSessionStore {
    static let shared = RitualSessionStore()
    private let key = "ritualSessions"

    private init() {}

    var all: [RitualSession] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let sessions = try? JSONDecoder().decode([RitualSession].self, from: data)
        else { return [] }
        return sessions
    }

    func session(for templateId: UUID) -> RitualSession? {
        all.first { $0.templateId == templateId && !$0.isFinished }
    }

    func save(_ session: RitualSession) {
        var current = all.filter { $0.templateId != session.templateId }
        current.append(session)
        persist(current)
    }

    func markFinished(templateId: UUID) {
        var current = all
        for i in current.indices where current[i].templateId == templateId {
            current[i].isFinished = true
        }
        persist(current)
    }

    func clear(templateId: UUID) {
        persist(all.filter { $0.templateId != templateId })
    }

    func clearUnfinishedIfNewDay() {
        let dayKey = "ritualSessionLastActiveDay"
        let cal    = Calendar.current
        let today  = cal.startOfDay(for: Date())

        if let stored = UserDefaults.standard.object(forKey: dayKey) as? Date,
           cal.isDate(stored, inSameDayAs: today) {
            return  // same day — nothing to reset
        }

        persist(all.filter { $0.isFinished })
        UserDefaults.standard.set(today, forKey: dayKey)
    }

    private func persist(_ sessions: [RitualSession]) {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
