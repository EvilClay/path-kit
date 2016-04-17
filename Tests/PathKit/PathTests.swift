import XCTest
import C7
@testable import PathKit

class PathTests: XCTestCase {

    func testSeparator() {
        XCTAssertEqual(Path.separator, "/")
    }

    // MARK: Initialization

    func testInitialization() {
        let path = Path()
        XCTAssertEqual(path.description, "")
    }

    func testInitializationWithString() {
        let path = Path("/usr/bin/swift")
        XCTAssertEqual(path.description, "/usr/bin/swift")
    }

    func testInitializationWithComponents() {
        let path = Path(components: ["/usr", "bin", "swift"])
        XCTAssertEqual(path, Path("/usr/bin/swift"))
    }

    // MARK: Convertable

    func testStringLiteralIsConvertableToPath() {
        let path: Path = "/usr/bin/swift"
        XCTAssertEqual(path, Path("/usr/bin/swift"))
    }

    // MARK: Equatable

    func testEqualPath() {
        XCTAssertEqual(Path("/usr/bin/swift"), Path("/usr/bin/swift"))
    }

    func testUnEqualPath() {
        XCTAssertNotEqual(Path("/usr/bin/swift"), Path("/usr/bin/python"))
    }

    // MARK: Hashable

    func testHashable() {
        XCTAssertEqual(Path("/usr/bin/swift").hashValue, Path("/usr/bin/swift").hashValue)
    }

    // MARK: Printable

    func testPathDescription() {
        let path = Path("/usr/bin/swift")
        XCTAssertEqual(path.description, "/usr/bin/swift")
    }

    // MARK: Pattern Matching

    func testMatches() {
        XCTAssertFalse(Path("/var")  ~= "~")
        XCTAssertTrue(Path("/Users") ~= "/Users")
        XCTAssertTrue(Path("/Users") ~= "~/..")
    }

    // MARK: Comparable

    func testCompare() {
        XCTAssertTrue(Path("a") < Path("b"))
    }

    // MARK: Appending

    func testAppendPath() {
        // Trivial cases.
        XCTAssertEqual(Path("a/b"), "a" + "b")
        XCTAssertEqual(Path("a/b"), "a/" + "b")

        // Appending (to) absolute paths
        XCTAssertEqual(Path("/"),  "/" + "/")
        XCTAssertEqual(Path("/"),  "/" + "..")
        XCTAssertEqual(Path("/a"), "/" + "../a")
        XCTAssertEqual(Path("/b"), "a" + "/b")

        // Appending (to) '.'
        XCTAssertEqual(Path("a"), "a" + ".")
        XCTAssertEqual(Path("a"), "a" + "./.")
        XCTAssertEqual(Path("a"), "." + "a")
        XCTAssertEqual(Path("a"), "./." + "a")
        XCTAssertEqual(Path("."), "." + ".")
        XCTAssertEqual(Path("."), "./." + "./.")

        // Appending (to) '..'
        XCTAssertEqual(Path("."),       "a" + "..")
        XCTAssertEqual(Path("a"),       "a/b" + "..")
        XCTAssertEqual(Path("../.."),   ".." + "..")
        XCTAssertEqual(Path("b"),       "a" + "../b")
        XCTAssertEqual(Path("a/c"),     "a/b" + "../c")
        XCTAssertEqual(Path("a/b/d/e"), "a/b/c" + "../d/e")
        XCTAssertEqual(Path("../../a"), ".." + "../a")
    }

}
