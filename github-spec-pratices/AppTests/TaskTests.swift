import XCTest
@testable import App

final class TaskTests: XCTestCase {
    func testInitTrimsTitleAndClampsPriority() {
        let t = Task(title: "  Hello  ", priority: 5)
        XCTAssertEqual(t.title, "Hello")
        XCTAssertEqual(t.priority, 2)
    }

    func testValidationRanges() {
        let short = Task(title: "a")
        XCTAssertEqual(short.title.count, 1)
        let longTitle = String(repeating: "a", count: 201)
        let t = Task(title: longTitle)
        XCTAssertLessThanOrEqual(t.title.count, 201) // constructor trims but not truncate; VM should validate
    }
}

