import XCTest
@testable import PathKit

class FileInfoTests: BaseTests {

    func testExistingPathExists() {
        XCTAssertTrue(fixtures.exists)
    }

    func testNonExistingPathDoesntExist() {
        let path = Path("/pathkit/test")
        XCTAssertFalse(path.exists)
    }

    func testIsDirectory() {
        XCTAssertTrue((fixtures + "directory").isDirectory)
        XCTAssertTrue((fixtures + "symlinks/directory").isDirectory)
    }

    func testIsSymlink() {
        XCTAssertFalse((fixtures + "file/file").isSymlink)
        XCTAssertTrue((fixtures + "symlinks/file").isSymlink)
    }

    func testIsFile() {
        XCTAssertTrue((fixtures + "file").isFile)
        XCTAssertTrue((fixtures + "symlinks/file").isFile)
    }

    func testIsExecutable() {
        XCTAssertTrue((fixtures + "permissions/executable").isExecutable)
    }

    func testIsReadable() {
        XCTAssertTrue((fixtures + "permissions/readable").isReadable)
    }

    func testIsWriteable() {
        XCTAssertTrue((fixtures + "permissions/writable").isWritable)
    }

}

extension FileInfoTests {
    static var allTests: [(String, FileInfoTests -> () throws -> Void)] {
        return [
            ("testExistingPathExists", testExistingPathExists),
            ("testNonExistingPathDoesntExist", testNonExistingPathDoesntExist),
            ("testIsDirectory", testIsDirectory),
            ("testIsSymlink", testIsSymlink),
            ("testIsFile", testIsFile),
            ("testIsExecutable", testIsExecutable),
            ("testIsReadable", testIsReadable),
            ("testIsWriteable", testIsWriteable),
        ]
    }
}
