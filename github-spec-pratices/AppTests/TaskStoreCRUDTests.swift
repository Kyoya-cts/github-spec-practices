import XCTest
@testable import App

final class TaskStoreCRUDTests: XCTestCase {
    func makeStore() -> TaskStore {
        let suite = UserDefaults(suiteName: "TaskStoreCRUD-")!
        suite.removePersistentDomain(forName: "TaskStoreCRUD-")
        return TaskStore(key: "tasks_v1_test", defaults: suite)
    }

    func testAddUpdateToggleDelete() {
        let store = makeStore()
        store.add(title: "Task1", priority: 0)
        XCTAssertEqual(store.tasks.count, 1)
        var t = store.tasks[0]
        XCTAssertFalse(t.isDone)

        // toggle
        store.toggle(t.id)
        t = store.tasks[0]
        XCTAssertTrue(t.isDone)

        // update
        var updated = t
        updated.title = "Task1-updated"
        updated.priority = 2
        store.update(updated)
        XCTAssertEqual(store.tasks[0].title, "Task1-updated")
        XCTAssertEqual(store.tasks[0].priority, 2)

        // delete
        store.delete(updated.id)
        XCTAssertEqual(store.tasks.count, 0)
    }
}

