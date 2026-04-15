import SwiftUI

final class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []

    init() {
        refresh()
    }

    func refresh() {
        let completions = CompletionStore.shared.all
        let cosmeticItems = loadCosmeticItems()
        let rituals = loadRituals()
        let streak = computeStreak(completions: completions)
        let totalCompletions = completions.count

        let cal = Calendar.current
        let now = Date()
        let monthCompletions = completions.filter {
            cal.isDate($0.completedAt, equalTo: now, toGranularity: .month)
        }.count

        let maskItems = cosmeticItems.filter { $0.category == .masks }.count
        let totalItems = cosmeticItems.count
        let categoryCount = Set(cosmeticItems.map { $0.category }).count
        let customRituals = rituals.filter { !$0.isDefault }.count

        achievements = [
            Achievement(id: 1,  name: "7 Days Streak",           iconName: "consistency_1", category: .consistency, isUnlocked: streak >= 7),
            Achievement(id: 2,  name: "14 Days Streak",          iconName: "consistency_2", category: .consistency, isUnlocked: streak >= 14),
            Achievement(id: 3,  name: "30 Days Streak",          iconName: "consistency_3", category: .consistency, isUnlocked: streak >= 30),
            Achievement(id: 4,  name: "10 Rituals Completed",    iconName: "consistency_4", category: .consistency, isUnlocked: totalCompletions >= 10),
            Achievement(id: 5,  name: "30 Rituals in a Month",   iconName: "consistency_5", category: .consistency, isUnlocked: monthCompletions >= 30),

            Achievement(id: 6,  name: "Tried 3 Different Masks", iconName: "experiments_1", category: .experiments, isUnlocked: maskItems >= 3),
            Achievement(id: 7,  name: "Tried 5 Different Masks", iconName: "experiments_2", category: .experiments, isUnlocked: maskItems >= 5),
            Achievement(id: 8,  name: "Used 3 New Products",     iconName: "experiments_3", category: .experiments, isUnlocked: totalItems >= 3),
            Achievement(id: 9,  name: "Used 5 New Products",     iconName: "experiments_4", category: .experiments, isUnlocked: totalItems >= 5),
            Achievement(id: 10, name: "Created a Custom Ritual", iconName: "experiments_5", category: .experiments, isUnlocked: customRituals >= 1),

            Achievement(id: 11, name: "5-Minute Ritual",         iconName: "speed_1", category: .speed, isUnlocked: totalCompletions >= 1),
            Achievement(id: 12, name: "Quick Finish",            iconName: "speed_2", category: .speed, isUnlocked: totalCompletions >= 5),
            Achievement(id: 13, name: "Fast Routine",            iconName: "speed_3", category: .speed, isUnlocked: totalCompletions >= 10),
            Achievement(id: 14, name: "Perfect Timing",          iconName: "speed_4", category: .speed, isUnlocked: totalCompletions >= 20),
            Achievement(id: 15, name: "No Time Wasted",          iconName: "speed_5", category: .speed, isUnlocked: totalCompletions >= 50),

            Achievement(id: 16, name: "Added 5 Products",        iconName: "collector_1", category: .collector, isUnlocked: totalItems >= 5),
            Achievement(id: 17, name: "Added 10 Products",       iconName: "collector_2", category: .collector, isUnlocked: totalItems >= 10),
            Achievement(id: 18, name: "Added 20 Products",       iconName: "collector_3", category: .collector, isUnlocked: totalItems >= 20),
            Achievement(id: 19, name: "Skincare Starter Set",    iconName: "collector_4", category: .collector, isUnlocked: categoryCount >= 3),
            Achievement(id: 20, name: "Full Care Set",           iconName: "collector_5", category: .collector, isUnlocked: categoryCount >= CosmeticCategory.allCases.count),

            Achievement(id: 21, name: "Completed All Steps Once",    iconName: "master_1", category: .master, isUnlocked: totalCompletions >= 1),
            Achievement(id: 22, name: "Completed All Steps 5 Times", iconName: "master_2", category: .master, isUnlocked: totalCompletions >= 5),
            Achievement(id: 23, name: "Completed All Steps 10 Times",iconName: "master_3", category: .master, isUnlocked: totalCompletions >= 10),
            Achievement(id: 24, name: "No Skips",                    iconName: "master_4", category: .master, isUnlocked: totalCompletions >= 25),
            Achievement(id: 25, name: "Ritual Master",               iconName: "master_5", category: .master, isUnlocked: totalCompletions >= 100)
        ]
    }

    var unlockedCount: Int { achievements.filter(\.isUnlocked).count }
    var totalCount: Int { achievements.count }

    private func computeStreak(completions: [RitualCompletion]) -> Int {
        let cal = Calendar.current
        let days = Set(completions.map { cal.startOfDay(for: $0.completedAt) })
        var streak = 0
        var check = cal.startOfDay(for: Date())
        while days.contains(check) {
            streak += 1
            check = cal.date(byAdding: .day, value: -1, to: check)!
        }
        return streak
    }

    private func loadCosmeticItems() -> [CosmeticItem] {
        guard let data = UserDefaults.standard.data(forKey: "savedCosmeticItems"),
              let items = try? JSONDecoder().decode([CosmeticItem].self, from: data)
        else { return [] }
        return items
    }

    private func loadRituals() -> [RitualTemplate] {
        guard let data = UserDefaults.standard.data(forKey: "savedRituals"),
              let items = try? JSONDecoder().decode([RitualTemplate].self, from: data)
        else { return LibraryViewModel.defaultRituals() }
        return items
    }
}
