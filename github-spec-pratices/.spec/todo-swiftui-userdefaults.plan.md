# Implementation Plan: SwiftUI + UserDefaults ToDo

**Branch**: `main` | **Date**: [fill on commit] | **Spec**: `.spec/todo-swiftui-userdefaults.md`
**Input**: Feature specification from `.spec/todo-swiftui-userdefaults.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → OK (.spec/todo-swiftui-userdefaults.md)
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Project Type = mobile (iOS SwiftUI)
   → Structure Decision = App/ with MVVM folders
3. Evaluate Constitution Check section below
   → No violations for MVP scope
4. Execute Phase 0 → research.md
   → Decisions recorded (Swift 5.9+, iOS 16+, SwiftUI, MVVM, UserDefaults JSON)
5. Execute Phase 1 → data-model.md, quickstart.md, contracts/
   → Entity: Task; No external API contracts (contracts N/A)
6. Re-evaluate Constitution Check section
   → Still OK
7. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
   → Use TDD ordering, mark independent tasks [P]
8. STOP - Ready for /tasks command
```

## Summary
Implement an offline ToDo app for iOS 16+ using SwiftUI and MVVM. Persist an array of `Task` via `UserDefaults` under key `tasks_v1` using `Codable` JSON. Provide list filtering (すべて/未完了/完了), sorting (作成日/締切日/優先度, 昇順/降順), optional search, swipe actions (右=完了, 左=削除), and an edit form with validation.

## Technical Context
- Language/Version: Swift 5.9+
- Primary Dependencies: SwiftUI, Combine (ObservableObject/@Published)
- Storage: UserDefaults (JSON-encoded `[Task]`, key `tasks_v1`)
- Testing: XCTest (unit) + XCUITest (UI)
- Target Platform: iOS 16+, Xcode 15.4
- Project Type: mobile (single iOS app target)
- Performance Goals: Smooth scroll (~60 fps) on large lists
- Constraints: Offline-only, simple persistence, validation before save

## Constitution Check
Simplicity:
- Projects: 1 app target (+ tests)
- Using SwiftUI directly; no custom wrapper layers
- Single core data model (`Task`); no DTOs needed
- Avoid over-engineering (no Repository/UoW)

Architecture:
- MVVM at view-feature granularity; no extra libraries

Testing (NON-NEGOTIABLE):
- Tests defined to precede implementation; contract/UI tests for flows; unit tests for store and view models

Observability:
- Basic error surfacing via validation messages; logging not required for local MVP

Versioning:
- App versioning out of scope; data version key optional (`data_version`)

## Project Structure

### Documentation (this feature)
```
.spec/
  todo-swiftui-userdefaults.plan.md     # This file (/plan)
  todo-swiftui-userdefaults.research.md # Phase 0 (/plan)
  todo-swiftui-userdefaults.data-model.md # Phase 1 (/plan)
  todo-swiftui-userdefaults.quickstart.md # Phase 1 (/plan)
  todo-swiftui-userdefaults.tasks.md     # Phase 2 (/tasks)
  contracts/README.md                    # N/A for local app
```

### Source Code (repository root)
```
App/
  AppMain.swift
  Features/
    TaskList/
      TaskListView.swift
      TaskListViewModel.swift
    TaskEdit/
      TaskEditView.swift
      TaskEditViewModel.swift
  Models/
    Task.swift
  Services/
    TaskStore.swift
  Utils/
    AppError.swift
```

**Structure Decision**: Mobile app with `App/` root and MVVM folders (SwiftUI)

## Phase 0: Outline & Research
Unknowns: None critical; versions pinned (iOS 16+, Swift 5.9+, Xcode 15.4). Persistence selected as `UserDefaults` with `Codable` JSON. Accessibility and Dynamic Type to be respected.

Output: See `.spec/todo-swiftui-userdefaults.research.md`.

## Phase 1: Design & Contracts
Entities: `Task { id, title, note?, isDone, priority(0..2), dueDate?, createdAt, updatedAt }`; validation rules applied in ViewModel.
Contracts: No external API; local-only persistence.
Quickstart: Describe creating the Xcode project, wiring files, running tests.

Outputs: See `.spec/todo-swiftui-userdefaults.data-model.md`, `.spec/todo-swiftui-userdefaults.quickstart.md`, `.spec/contracts/README.md`.

## Phase 2: Task Planning Approach (description only)
Task Generation Strategy:
- Use `templates/tasks-template.md` ordering; derive tasks from entity and flows
- Mark independent file-scoped tasks with [P]

Ordering Strategy:
- Tests → Models → Store/Services → ViewModels → Views → Polish

Estimated Output: ~25–30 tasks in tasks.md (already drafted for this spec)

