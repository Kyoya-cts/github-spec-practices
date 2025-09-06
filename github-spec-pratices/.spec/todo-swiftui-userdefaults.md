# ToDo アプリ要件（SwiftUI + UserDefaults）

AI エージェントが SwiftUI で最小の ToDo アプリを実装できるように、環境、構成、データモデル、永続化方式（UserDefaults）、UI フロー、検収条件を定義します。ローカル専用で、同期やマルチユーザーは対象外です。

## 目的とスコープ

- 目的: iOS 端末内で完結する ToDo 管理
- スコープ: タスクの追加/編集/削除/完了トグル、一覧のフィルタ/ソート/検索（任意）
- 非スコープ: 通知、クラウド同期、複数端末連携、ログイン

## 技術スタックとバージョン

- iOS: 16.0 以上
- Xcode: 15.x（推奨 15.4）
- Swift: 5.9+
- UI: SwiftUI
- アーキテクチャ: MVVM
- 永続化: UserDefaults（`Codable` で JSON 保存）。キー: `tasks_v1`

## プロジェクト構成（推奨）

```
App/
  AppMain.swift (@main)
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
    TaskStore.swift (UserDefaults ベース)
  Utils/
    AppError.swift
  Resources/
    Assets.xcassets
```

## データモデル

`Task`（Codable, Identifiable）
- `id: UUID`
- `title: String`（1..200）
- `note: String?`
- `isDone: Bool`（既定: false）
- `priority: Int`（0:低, 1:中, 2:高 / 既定: 1）
- `dueDate: Date?`
- `createdAt: Date`
- `updatedAt: Date`

バリデーション
- `title`: トリム後に 1..200 文字
- `priority`: 0..2

## 永続化（UserDefaults）

- 保存キー: `"tasks_v1"`
- 保存形式: `[Task]` を `JSONEncoder` でエンコードして `Data` を保存
- 読込: `Data` を `JSONDecoder` で `[Task]` に復元。復元失敗時は空配列にフォールバック
- 変更時（追加/更新/削除/トグル）に即時保存
- 将来の拡張に備え、`version` キー（例: `"data_version": 1`）を別途保存し、簡易マイグレーションに対応可能な構造にする（必須ではない）

## 画面とユーザーフロー

- タスク一覧（起動時）
  - セグメント: `すべて / 未完了 / 完了` 切替
  - ソート: `作成日 / 締切日 / 優先度`（昇順/降順）
  - 検索バー（任意）: タイトル/メモの部分一致
  - 行のスワイプ: 右→完了トグル、左→削除
  - 追加ボタン（+）で編集画面へ

- タスク編集（追加/編集）
  - 入力: タイトル、メモ、締切、優先度（セグメント）
  - 保存で戻る（新規は追加、既存は上書き）
  - バリデーション NG は保存不可 + エラーメッセージ表示

## 実装指針（MVVM）

- `TaskStore`: `ObservableObject`。`@Published var tasks: [Task]` を保持し、`load()/save()`、`add/update/delete/toggle` を提供
- `TaskListViewModel`: 絞り込み・並べ替えロジック、表示用配列を公開
- `TaskEditViewModel`: フォーム状態と保存ロジック
- 依存注入: ルートで `@StateObject var store = TaskStore()` を作成し、`environmentObject` で配下に共有

## サンプルコード断片

- モデル
```swift
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

  init(id: UUID = UUID(), title: String, note: String? = nil, isDone: Bool = false, priority: Int = 1, dueDate: Date? = nil, createdAt: Date = .now, updatedAt: Date = .now) {
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
```

- UserDefaults ストア
```swift
import Foundation
import Combine

final class TaskStore: ObservableObject {
  @Published private(set) var tasks: [Task] = []
  private let key = "tasks_v1"
  private let defaults = UserDefaults.standard

  init() { load() }

  func load() {
    guard let data = defaults.data(forKey: key) else { tasks = []; return }
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
```

## 受け入れ基準（MVP）

- タスクを追加し、アプリ再起動後も一覧に残る（UserDefaults 保存）
- タスクの完了トグルが機能し、一覧に即時反映される
- タスクの編集・削除が機能する
- フィルタ（すべて/未完了/完了）が機能する
- ソート（作成日/締切日/優先度）が機能する

## エラーハンドリングと UX

- バリデーション NG 時は保存ボタンを無効化し、短い説明を表示
- 長いリストでもスクロールが滑らか（目安 60fps）
- Dynamic Type と VoiceOver 対応（`accessibilityLabel`）

## ストレッチ（任意）

- 検索バー（`searchable`）
- ウィジェットやショートカット連携
- iCloud Key-Value で簡易同期（後続）

