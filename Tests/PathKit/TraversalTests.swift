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
            let children = try fixtures.children()
            XCTAssertEqual(children, ["directory", "file", "permissions", "symlinks"].map { fixtures + $0 })
        }
    }

    func testChildrenWithoutDirectories() {
        AssertNoThrow {
            let children = try fixtures.children().filter { $0.isFile }
            XCTAssertEqual(children, [fixtures + "file"])
        }
    }

    func testRecursiveChildren() {
        AssertNoThrow {
            let parent = fixtures + "directory"
            let children = try parent.recursiveChildren()
            XCTAssertEqual(children, ["child", "subdirectory", "subdirectory/child"].map { parent + $0 })
        }
    }

}
