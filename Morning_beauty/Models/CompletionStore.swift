import Foundation

final class CompletionStore {
    static let shared = CompletionStore()
    private let key = "ritualCompletions"

    private init() {}

    var all: [RitualCompletion] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([RitualCompletion].self, from: data)
        else { return [] }
        return items
    }

    func record(_ completion: RitualCompletion) {
        var current = all
        current.append(completion)
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func completions(for date: Date, calendar: Calendar = .current) -> [RitualCompletion] {
        all.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }
    }

    func completions(from start: Date, to end: Date) -> [RitualCompletion] {
        all.filter { $0.completedAt >= start && $0.completedAt <= end }
    }
}
