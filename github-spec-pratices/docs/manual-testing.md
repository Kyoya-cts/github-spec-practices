# Manual Testing Checklist – SwiftUI + UserDefaults ToDo

## Pre-requisites
- iOS 16+ simulator or device
- Xcode 15.4
- Build app with provided sources under `App/`

## Basic Flows
- [ ] Add a task: Tap `+`, enter title, Save → Appears at top
- [ ] Persist: Stop & relaunch app → Task remains listed
- [ ] Toggle done: Swipe right on a row → checkmark appears/disappears immediately
- [ ] Edit task: Tap a row, change title/priority, Save → List updates
- [ ] Delete task: Swipe left on a row → Removed from list

## Filters & Sort
- [ ] Filter: Switch `すべて/未完了/完了` shows correct subsets
- [ ] Sort: Change key (`作成日/締切日/優先度`) and order (昇順/降順) reflects in list ordering

## Validation & UX
- [ ] Title validation: Empty title disables Save and shows message
- [ ] Priority bounds: Values are within 0..2 via segmented control
- [ ] Dynamic Type: Larger Accessibility sizes keep layout usable
- [ ] VoiceOver: Buttons and rows have meaningful labels

## Performance
- [ ] Add 300+ tasks (script or manual) → Scroll is smooth (~60fps target)

