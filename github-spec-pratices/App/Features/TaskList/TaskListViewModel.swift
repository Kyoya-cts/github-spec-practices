import Foundation

final class TaskListViewModel: ObservableObject {
    enum Filter: String, CaseIterable, Identifiable {
        case all = "すべて"
        case active = "未完了"
        case done = "完了"
        var id: String { rawValue }
    }

    enum SortKey: String, CaseIterable, Identifiable {
        case createdAt = "作成日"
        case dueDate = "締切日"
        case priority = "優先度"
        var id: String { rawValue }
    }

    @Published var filter: Filter = .all
    @Published var sortKey: SortKey = .createdAt
    @Published var ascending: Bool = false
    @Published var searchText: String = ""

    func filtered(tasks: [Task]) -> [Task] {
        var items = tasks
        // Filter
        switch filter {
        case .all:
            break
        case .active:
            items = items.filter { !$0.isDone }
        case .done:
            items = items.filter { $0.isDone }
        }

        // Search (optional)
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !q.isEmpty {
            items = items.filter { t in
                t.title.localizedCaseInsensitiveContains(q) || (t.note?.localizedCaseInsensitiveContains(q) ?? false)
            }
        }

        // Sort
        items.sort { a, b in
            let cmp: ComparisonResult
            switch sortKey {
            case .createdAt:
                cmp = a.createdAt.compare(b.createdAt)
            case .dueDate:
                switch (a.dueDate, b.dueDate) {
                case let (d1?, d2?): cmp = d1.compare(d2)
                case (_?, nil): cmp = .orderedAscending
                case (nil, _?): cmp = .orderedDescending
                default: cmp = .orderedSame
                }
            case .priority:
                if a.priority == b.priority { cmp = .orderedSame }
                else { cmp = a.priority < b.priority ? .orderedAscending : .orderedDescending }
            }
            return ascending ? (cmp != .orderedDescending) : (cmp == .orderedDescending)
        }
        return items
    }
}

