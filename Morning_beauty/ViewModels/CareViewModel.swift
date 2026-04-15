import SwiftUI

final class CareViewModel: ObservableObject {
    private static let storageKey = "savedCosmeticItems"

    @Published var items: [CosmeticItem] {
        didSet { save() }
    }
    @Published var selectedCategory: CosmeticCategory? = nil
    @Published var showAddCosmetic = false

    var filteredItems: [CosmeticItem] {
        guard let cat = selectedCategory else { return items }
        return items.filter { $0.category == cat }
    }

    init() {
        self.items = CareViewModel.load() ?? []
    }

    func addItem(_ item: CosmeticItem) {
        items.append(item)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private static func load() -> [CosmeticItem]? {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let items = try? JSONDecoder().decode([CosmeticItem].self, from: data)
        else { return nil }
        return items
    }
}
