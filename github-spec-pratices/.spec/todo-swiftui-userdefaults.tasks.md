# Tasks: SwiftUI + UserDefaults ToDo

**Input**: `.spec/todo-swiftui-userdefaults.md`
**Prerequisites**: plan.md (optional), spec file above

## Phase 3.1: Setup
- [ ] T001 Create Xcode project and folders per spec in `App/` (AppMain, Features, Models, Services, Utils, Resources)
- [ ] T002 Add targets `AppTests` and `AppUITests` to the Xcode project
- [ ] T003 [P] Add lint/format configs (`.swiftlint.yml`, `.swiftformat`) at repo root

## Phase 3.2: Tests First (TDD) — must fail initially
- [ ] T004 [P] Unit test Task validation in `AppTests/TaskTests.swift` (title 1..200, priority 0..2, trimming)
- [ ] T005 [P] Unit test TaskStore load/save in `AppTests/TaskStoreTests.swift` (UserDefaults key `tasks_v1`, JSON encode/decode, fallback empty on decode error)
- [ ] T006 [P] Unit test TaskStore CRUD/toggle in `AppTests/TaskStoreCRUDTests.swift` (add/update/delete/toggle, updates `updatedAt`)
- [ ] T007 [P] Unit test filtering/sorting in `AppTests/TaskListViewModelTests.swift` (all/active/done; by createdAt/dueDate/priority asc/desc)
- [ ] T008 [P] UI test add/toggle/delete flow in `AppUITests/TaskFlowUITests.swift` (plus → form → save; swipe right=toggle; swipe left=delete)
- [ ] T009 [P] UI test edit/validation in `AppUITests/TaskEditUITests.swift` (invalid title disables Save; error message visible)

## Phase 3.3: Core Implementation
- [ ] T010 [P] Implement model `Task` in `App/Models/Task.swift` (Codable, Identifiable, Equatable; fields/defaults per spec; clamp priority; trim title)
- [ ] T011 [P] Implement store `TaskStore` in `App/Services/TaskStore.swift` (ObservableObject, @Published tasks, load/save with JSON, CRUD/toggle, immediate persist)
- [ ] T012 [P] Implement `TaskListViewModel` in `App/Features/TaskList/TaskListViewModel.swift` (filter segment, sort mode/dir, computed list)
- [ ] T013 [P] Implement `TaskEditViewModel` in `App/Features/TaskEdit/TaskEditViewModel.swift` (form state, validation, save new/update existing)
- [ ] T014 App entry `@main` in `App/AppMain.swift` (create `@StateObject var store = TaskStore()`, inject via `.environmentObject(store)`)
- [ ] T015 Implement list UI in `App/Features/TaskList/TaskListView.swift` (segment: すべて/未完了/完了, sort control, optional `searchable`, swipe: right=toggle, left=delete, + to edit)
- [ ] T016 Implement edit UI in `App/Features/TaskEdit/TaskEditView.swift` (title, note, dueDate, priority segmented; validation disables Save; Save returns)
- [ ] T017 Input validation and messages in `App/Utils/AppError.swift` and applied in view models
- [ ] T018 Wire navigation between list and edit (sheet or NavigationStack, pass existing task to edit)

## Phase 3.4: Integration
- [ ] T019 Ensure immediate persistence on all mutations in `App/Services/TaskStore.swift` (verify via relaunch)
- [ ] T020 Optional: write/read `data_version` in `UserDefaults` within `App/Services/TaskStore.swift` (future migration scaffold)
- [ ] T021 Accessibility in `App/Features/*/*.swift` (labels/traits; Dynamic Type friendly layout)
- [ ] T022 Performance pass for large lists in `App/Features/TaskList/TaskListView.swift` (use `List`, avoid heavy work in `body`, verify smooth scroll)

## Phase 3.5: Polish
- [ ] T023 [P] Add unit tests for edge cases in `AppTests/ValidationEdgeCaseTests.swift` (200-char title, priority bounds, nil dueDate)
- [ ] T024 [P] Add unit tests for sorting stability/secondary keys in `AppTests/TaskListSortingTests.swift`
- [ ] T025 Update docs in `README.md` (build/run, iOS 16+, Xcode 15.4, structure, test instructions)
- [ ] T026 Manual QA checklist in `docs/manual-testing.md` (acceptance criteria from spec)
- [ ] T027 Remove duplication and minor refactors across view models/views

## Dependencies
- Tests (T004–T009) before implementation (T010–T018)
- T010 blocks T011; T011 blocks T012–T016; T014 depends on T011
- T015–T018 depend on corresponding view models
- Implementation before polish (T023–T027)

## Parallel Example
Launch T004, T005, T006, T007, T008, T009 together (different files, no dependencies)

## Notes
- [P] = safe to run in parallel (different files, no deps)
- Verify tests fail before implementing
- Commit after each task; avoid overlapping writes to same file across parallel tasks
