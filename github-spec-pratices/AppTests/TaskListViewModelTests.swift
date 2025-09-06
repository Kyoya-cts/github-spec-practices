import XCTest
@testable import App

final class TaskListViewModelTests: XCTestCase {
    func sampleTasks() -> [Task] {
        [
            Task(title: "A", isDone: false, priority: 2, createdAt: Date(timeIntervalSince1970: 10), updatedAt: Date(timeIntervalSince1970: 10)),
            Task(title: "B", isDone: true, priority: 1, createdAt: Date(timeIntervalSince1970: 20), updatedAt: Date(timeIntervalSince1970: 20)),
            Task(title: "C", isDone: false, priority: 0, dueDate: Date(timeIntervalSince1970: 100), createdAt: Date(timeIntervalSince1970: 30), updatedAt: Date(timeIntervalSince1970: 30))
        ]
    }

    func testFilterActiveDone() {
        let vm = TaskListViewModel()
        let tasks = sampleTasks()
        vm.filter = .active
        XCTAssertEqual(vm.filtered(tasks: tasks).filter { !$0.isDone }.count, 2)
        vm.filter = .done
        XCTAssertEqual(vm.filtered(tasks: tasks).filter { $0.isDone }.count, 1)
    }

    func testSortByCreatedDescendingThenAscending() {
        let vm = TaskListViewModel()
        let tasks = sampleTasks()
        vm.sortKey = .createdAt
        vm.ascending = false
        let desc = vm.filtered(tasks: tasks)
        XCTAssertEqual(desc.map { $0.title }, ["C","B","A"]) // createdAt 30,20,10
        vm.ascending = true
        let asc = vm.filtered(tasks: tasks)
        XCTAssertEqual(asc.map { $0.title }, ["A","B","C"]) // 10,20,30
    }

    func testSortByDueDatePlacesNilLastWhenAscending() {
        let vm = TaskListViewModel()
        var tasks = sampleTasks()
        // Ensure one with nil dueDate
        tasks[0].dueDate = nil
        tasks[1].dueDate = Date(timeIntervalSince1970: 50)
        tasks[2].dueDate = Date(timeIntervalSince1970: 100)
        vm.sortKey = .dueDate
        vm.ascending = true
        let sorted = vm.filtered(tasks: tasks)
        XCTAssertEqual(sorted.last?.title, "A") // nil dueDate goes last
    }
}

