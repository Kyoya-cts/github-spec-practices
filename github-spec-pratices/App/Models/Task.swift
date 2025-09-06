import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var note: String?
    var isDone: Bool
    var priority: Int
    var dueDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        note: String? = nil,
        isDone: Bool = false,
        priority: Int = 1,
        dueDate: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.note = note
        self.isDone = isDone
        self.priority = min(max(priority, 0), 2)
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

