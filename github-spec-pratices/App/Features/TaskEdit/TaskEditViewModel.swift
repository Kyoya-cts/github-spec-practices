import Foundation

final class TaskEditViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var note: String? = nil
    @Published var dueDate: Date? = nil
    @Published var priority: Int = 1
    @Published var errorMessage: String? = nil

    private(set) var editing: Task? = nil

    init(editing: Task? = nil) {
        if let t = editing {
            self.editing = t
            self.title = t.title
            self.note = t.note
            self.dueDate = t.dueDate
            self.priority = t.priority
        }
    }

    var isValid: Bool {
        validate() == nil
    }

    func validate() -> String? {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.count < 1 || t.count > 200 { return "タイトルは1〜200文字" }
        if priority < 0 || priority > 2 { return "優先度は0..2" }
        return nil
    }

    func makeTask() -> Task {
        if var base = editing {
            base.title = title
            base.note = note
            base.priority = priority
            base.dueDate = dueDate
            base.updatedAt = .now
            return base
        } else {
            return Task(title: title, note: note, priority: priority, dueDate: dueDate)
        }
    }

    func save(into store: TaskStore) {
        if let err = validate() { self.errorMessage = err; return }
        let t = makeTask()
        if editing != nil {
            store.update(t)
        } else {
            store.add(title: t.title, note: t.note, priority: t.priority, dueDate: t.dueDate)
        }
    }
}

