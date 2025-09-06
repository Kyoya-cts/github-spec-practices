# Quickstart – SwiftUI + UserDefaults ToDo

## Requirements
- Xcode 15.4, iOS 16+ Simulator or device

## Steps
1) Create a new iOS App (SwiftUI) project in Xcode (module name: `App`).
2) Add sources from this repo:
   - Add all files under `App/` to the app target.
   - Add test files under `AppTests/` and `AppUITests/` to their respective targets.
3) Build and run tests (⌘U). Unit tests should pass.
4) Run the app (⌘R). Verify flows per `docs/manual-testing.md`.

## Notes
- If your module name differs, update `@testable import App` in test files.
- To reset stored tasks during development, delete the app from the simulator.

