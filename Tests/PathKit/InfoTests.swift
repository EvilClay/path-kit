import XCTest
@testable import PathKit

class InfoTests: BaseTests {

    func testConvertingRelativeToAbsolute() {
        let path = Path("swift")
        XCTAssertEqual(path.absolute(), Path.current! + Path("swift"))
    }

    func testConvertingAbsoluteToAbsolute() {
        let path = Path("/usr/bin/swift")
        XCTAssertEqual(path.absolute(), Path("/usr/bin/swift"))
    }

    func testAbsolutePathIsAbsolute() {
        let path = Path("/usr/bin/swift")
        XCTAssertTrue(path.isAbsolute)
    }

    func testRelativePathIsNotAbsolute() {
        let path = Path("swift")
        XCTAssertFalse(path.isAbsolute)
    }

    func testRelativePathIsRelative() {
        let path = Path("swift")
        XCTAssertTrue(path.isRelative)
    }

    func testAbsolutePathIsNotRelative() {
        let path = Path("/usr/bin/swift")
        XCTAssertFalse(path.isRelative)
    }

    func testNormalize() {
        let path = Path("/usr/./local/../bin/swift")
        XCTAssertEqual(path.normalize(), Path("/usr/bin/swift"))
    }

    func testAbbreviate() {
        let path = Path("/Users/\(NSUserName())/Library")
        XCTAssertEqual(path.abbreviate(), Path("~/Library"))
    }

}

extension InfoTests {
    static var allTests: [(String, InfoTests -> () throws -> Void)] {
        return [
            ("testConvertingRelativeToAbsolute", testConvertingRelativeToAbsolute),
            ("testConvertingAbsoluteToAbsolute", testConvertingAbsoluteToAbsolute),
            ("testAbsolutePathIsAbsolute", testAbsolutePathIsAbsolute),
            ("testRelativePathIsNotAbsolute", testRelativePathIsNotAbsolute),
            ("testRelativePathIsRelative", testRelativePathIsRelative),
            ("testAbsolutePathIsNotRelative", testAbsolutePathIsNotRelative),
            ("testNormalize", testNormalize),
            ("testAbbreviate", testAbbreviate),
        ]
    }
}
