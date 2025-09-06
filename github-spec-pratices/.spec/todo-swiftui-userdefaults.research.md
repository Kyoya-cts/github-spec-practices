# Research – SwiftUI + UserDefaults ToDo

## Decisions
- UI: SwiftUI (iOS 16+, `NavigationStack`, `List`, `sheet`, `searchable`)
- Architecture: MVVM per feature (TaskList, TaskEdit)
- Persistence: `UserDefaults` with `Codable` JSON for `[Task]`, key `tasks_v1`
- Validation: Enforced in Edit ViewModel (title 1..200 after trim; priority 0..2)
- Accessibility: Use labels/traits, support Dynamic Type

## Rationale
- SwiftUI provides rapid, accessible UI with built-in list, navigation, and swipe actions
- UserDefaults is sufficient for single-device MVP; JSON encoding keeps it simple
- MVVM cleanly separates form/list logic from views without extra complexity

## Alternatives Considered
- Core Data: more robust but overkill for MVP; heavier boilerplate
- File storage: JSON file on disk; similar complexity, no clear benefit over UserDefaults for small data
- Redux-like state: unnecessary complexity for scope

## Open Items
- None for MVP. Optional `data_version` can be added for future migrations.

