import XCTest
@testable import PathKit

class TraversalTests: BaseTests {

    func testParent() {
        XCTAssertEqual((fixtures + "directory/child").parent(),    fixtures + "directory")
        XCTAssertEqual((fixtures + "symlinks/directory").parent(), fixtures + "symlinks")
        XCTAssertEqual((fixtures + "directory/..").parent(),       fixtures + "directory/../..")
        XCTAssertEqual(Path("/").parent(),                         "/")
    }

    func testChildren() {
        AssertNoThrow {
            let children = try fixtures.children().sorted()
            XCTAssertEqual(children, ["directory", "file", "read", "permissions", "symlinks"].map { fixtures + $0 }.sorted())
        }
    }

    func testChildrenWithoutDirectories() {
        AssertNoThrow {
            let children = try fixtures.children().filter { $0.isFile }.sorted()
            XCTAssertEqual(children, [fixtures + "file", fixtures + "read"].sorted())
        }
    }

    func testRecursiveChildren() {
        AssertNoThrow {
            let parent = fixtures + "directory"
            let children = try parent.recursiveChildren().sorted()
            XCTAssertEqual(children, ["child", "subdirectory", "subdirectory/child"].map { parent + $0 }.sorted())
        }
    }

}

extension TraversalTests {
    static var allTests: [(String, TraversalTests -> () throws -> Void)] {
        return [
            ("testParent", testParent),
            ("testChildren", testChildren),
            ("testChildrenWithoutDirectories", testChildrenWithoutDirectories),
            ("testRecursiveChildren", testRecursiveChildren),
        ]
    }
}
