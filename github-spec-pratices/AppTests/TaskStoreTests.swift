import XCTest
@testable import App

final class TaskStoreTests: XCTestCase {
    func makeIsolatedStore() -> TaskStore {
        let suite = UserDefaults(suiteName: "TaskStoreTests-")!
        suite.removePersistentDomain(forName: "TaskStoreTests-")
        return TaskStore(key: "tasks_v1_test", defaults: suite)
    }

    func testLoadEmptyWhenNoData() {
        let store = makeIsolatedStore()
        XCTAssertEqual(store.tasks.count, 0)
    }

    func testSaveAndLoadRoundTrip() {
        let store = makeIsolatedStore()
        store.add(title: "A")
        XCTAssertEqual(store.tasks.count, 1)

        let store2 = makeIsolatedStore()
        store2.load()
        XCTAssertEqual(store2.tasks.count, 1)
        XCTAssertEqual(store2.tasks.first?.title, "A")
    }
}

