import Foundation
import Combine

final class TaskStore: ObservableObject {
    @Published private(set) var tasks: [Task] = []

    private let key: String
    private let defaults: UserDefaults

    init(key: String = "tasks_v1", defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
        load()
    }

    func load() {
        guard let data = defaults.data(forKey: key) else {
            tasks = []
            return
        }
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            tasks = []
        }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(tasks) {
            defaults.set(data, forKey: key)
        }
    }

    func add(title: String, note: String? = nil, priority: Int = 1, dueDate: Date? = nil) {
        var task = Task(title: title, note: note, priority: priority, dueDate: dueDate)
        task.updatedAt = .now
        tasks.insert(task, at: 0)
        persist()
    }

    func update(_ task: Task) {
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            var t = task
            t.updatedAt = .now
            tasks[idx] = t
            persist()
        }
    }

    func toggle(_ id: UUID) {
        if let idx = tasks.firstIndex(where: { $0.id == id }) {
            tasks[idx].isDone.toggle()
            tasks[idx].updatedAt = .now
            persist()
        }
    }

    func delete(_ id: UUID) {
        tasks.removeAll { $0.id == id }
        persist()
    }
}

