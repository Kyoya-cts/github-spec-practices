# Data Model – SwiftUI + UserDefaults ToDo

## Entity: Task
- id: UUID (Identifiable)
- title: String (trimmed, 1..200)
- note: String? (optional)
- isDone: Bool (default false)
- priority: Int (0:低, 1:中, 2:高; default 1; clamp to 0..2)
- dueDate: Date? (optional)
- createdAt: Date (default now)
- updatedAt: Date (default now; set on mutation)

## Validation Rules
- title: trim whitespaces/newlines, length must be within 1..200
- priority: clamp or reject outside 0..2; UI provides segmented control

## Persistence
- Storage: `UserDefaults.standard`
- Key: `tasks_v1`
- Encode: `[Task]` via `JSONEncoder`
- Decode: `[Task]` via `JSONDecoder`; on failure → empty array
- Optional: `data_version` key for future migrations

