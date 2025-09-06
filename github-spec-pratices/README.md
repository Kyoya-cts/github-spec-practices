## SwiftUI + UserDefaults ToDo (MVP)

This repo includes a minimal SwiftUI ToDo app scaffold per `.spec/todo-swiftui-userdefaults.md`.

Structure (suggested Xcode groups/paths):

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

Tests (create targets `AppTests` and `AppUITests` in Xcode and add files):

```
AppTests/
  TaskTests.swift
  TaskStoreTests.swift
  TaskStoreCRUDTests.swift
  TaskListViewModelTests.swift
AppUITests/
  TaskFlowUITests.swift
  TaskEditUITests.swift
```

Build requirements: iOS 16+, Xcode 15.4, Swift 5.9+.

Getting started:
- Create a new iOS SwiftUI app project in Xcode named `App` (or adjust module imports in tests)
- Add the source files from the `App/` folder to the App target
- Add the test files to their respective test targets
- Run unit tests first (they should pass with the current implementation)
- Run on Simulator, verify acceptance criteria in `docs/manual-testing.md`

