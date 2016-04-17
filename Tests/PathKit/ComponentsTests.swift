import XCTest
@testable import PathKit

class ComponentsTests: BaseTests {

    func testLastComponent() {
        XCTAssertEqual(Path("a/b/c.d").lastComponent, "c.d")
        XCTAssertEqual(Path("a/..").lastComponent,    "..")
    }

    func testLastComponentWithoutExtension() {
        XCTAssertEqual(Path("a/b/c.d").lastComponentWithoutExtension, "c")
        XCTAssertEqual(Path("a/..").lastComponentWithoutExtension,    ".")
    }

    func testComponents() {
        XCTAssertEqual(Path("a/b/c.d").components,   ["a", "b", "c.d"])
        XCTAssertEqual(Path("/a/b/c.d").components,  ["/", "a", "b", "c.d"])
        XCTAssertEqual(Path("~/a/b/c.d").components, ["~", "a", "b", "c.d"])
    }

    func testExtension() {
        XCTAssertEqual(Path("a/b/c.d").`extension`, "d")
        XCTAssertEqual(Path("a/b.c.d").`extension`, "d")
        XCTAssertNil(Path("a/b").`extension`)
    }

}
