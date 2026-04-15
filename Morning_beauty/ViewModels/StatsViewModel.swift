import SwiftUI

enum StatsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
}

struct BarEntry: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

struct PieSlice: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

final class StatsViewModel: ObservableObject {
    @Published var selectedPeriod: StatsPeriod = .week

    private var rituals: [RitualTemplate] {
        guard let data = UserDefaults.standard.data(forKey: "savedRituals"),
              let loaded = try? JSONDecoder().decode([RitualTemplate].self, from: data),
              !loaded.isEmpty
        else { return LibraryViewModel.defaultRituals() }
        return loaded
    }

    private var completions: [RitualCompletion] { CompletionStore.shared.all }

    var totalRituals: Int { completions.count }

    var averageTime: String {
        guard !rituals.isEmpty else { return "—" }
        let avg = rituals.map { $0.totalDuration }.reduce(0, +) / Double(rituals.count)
        let min = Int(avg / 60)
        return min > 0 ? "\(min) min" : "< 1 min"
    }

    var favoriteCategory: String {
        guard !completions.isEmpty else { return "—" }
        let counts = Dictionary(grouping: completions, by: { $0.ritualName }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key ?? "—"
    }

    var barData: [BarEntry] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        switch selectedPeriod {
        case .week:
            return (0..<7).map { offset -> BarEntry in
                let date = cal.date(byAdding: .day, value: -(6 - offset), to: today)!
                let day = cal.component(.day, from: date)
                let count = completions.filter { cal.isDate($0.completedAt, inSameDayAs: date) }.count
                return BarEntry(label: "\(day)", value: Double(count))
            }

        case .month:
            return (0..<4).map { weekOffset -> BarEntry in
                let weekEnd   = cal.date(byAdding: .day, value: -(3 - weekOffset) * 7, to: today)!
                let weekStart = cal.date(byAdding: .day, value: -6, to: weekEnd)!
                let count = completions.filter {
                    $0.completedAt >= weekStart &&
                    $0.completedAt <= cal.date(byAdding: .day, value: 1, to: weekEnd)!
                }.count
                let day = cal.component(.day, from: weekStart)
                return BarEntry(label: "W\(weekOffset + 1)\n(\(day))", value: Double(count))
            }
        }
    }

    private static let pieColors: [Color] = [
        Color(red: 1.0,  green: 0.82, blue: 0.45),
        Color(red: 0.35, green: 0.72, blue: 0.78),
        Color(red: 0.92, green: 0.55, blue: 0.52),
        Color(red: 0.62, green: 0.78, blue: 0.55),
        Color(red: 0.72, green: 0.55, blue: 0.88)
    ]

    var pieData: [PieSlice] {
        let cal = Calendar.current
        let today = Date()

        let periodStart: Date
        switch selectedPeriod {
        case .week:  periodStart = cal.date(byAdding: .day,   value: -7, to: today)!
        case .month: periodStart = cal.date(byAdding: .month, value: -1, to: today)!
        }

        let relevant = completions.filter { $0.completedAt >= periodStart }

        if relevant.isEmpty {
            return [
                PieSlice(label: "Morning",       value: 2, color: Self.pieColors[0]),
                PieSlice(label: "Evening",       value: 1, color: Self.pieColors[1]),
                PieSlice(label: "Special Cases", value: 1, color: Self.pieColors[2])
            ]
        }

        let counts = Dictionary(grouping: relevant, by: { $0.ritualName })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(5)

        return counts.enumerated().map { i, pair in
            PieSlice(
                label: pair.key,
                value: Double(pair.value),
                color: Self.pieColors[i % Self.pieColors.count]
            )
        }
    }
}
