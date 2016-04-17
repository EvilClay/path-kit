import XCTest
import C7
@testable import PathKit

class ReadWriteTests: BaseTests {

    func testReadData() {
        let path = Path("/etc/manpaths")
        let contents = AssertNoThrow(try path.read())
        let string = AssertNoThrow(try String(data: contents!))

        XCTAssertTrue(string?.hasPrefix("/usr/share/man") == true)
    }

    func testReadNonExistingData() {
        let path = Path("/tmp/pathkit-testing")

        do {
            try path.read()
            XCTFail("Error was not thrown from `read()`")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSCocoaErrorDomain)
            XCTAssertEqual(error.code, NSFileReadNoSuchFileError)
        }
    }

    func testReadString() {
        let path = Path("/etc/manpaths")
        let contents = try? path.readString()

        XCTAssertTrue(contents??.hasPrefix("/usr/share/man") ?? false)
    }

    func testReadNonExistingString() {
        let path = Path("/tmp/pathkit-testing")

        do {
            try path.readString()
            XCTFail("Error was not thrown from `read()`")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSCocoaErrorDomain)
            XCTAssertEqual(error.code, NSFileReadNoSuchFileError)
        }
    }

    func testWriteData() {
        let path = Path("/tmp/pathkit-testing")
        let data = Data("Hi")

        XCTAssertFalse(path.exists)

        AssertNoThrow(try path.write(data: data))
        XCTAssertEqual(try? path.read(), "Hi")
        AssertNoThrow(try path.delete())
    }

    func testWriteDataThrowsOnFailure() {
        let path = Path("/")
        let data = Data("Hi")

        do {
            try path.write(data: data)
            XCTFail("Error was not thrown from `write()`")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSCocoaErrorDomain)
            XCTAssertEqual(error.code, NSFileWriteNoPermissionError)
        }
    }

    func testWriteString() {
        let path = Path("/tmp/pathkit-testing")

        XCTAssertFalse(path.exists)

        AssertNoThrow(try path.write(string: "Hi"))
        XCTAssertEqual(try? path.read(), "Hi")
        AssertNoThrow(try path.delete())
    }

    func testWriteStringThrowsOnFailure() {
        let path = Path("/")

        do {
            try path.write(string: "hi")
            XCTFail("Error was not thrown from `write()`")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, NSCocoaErrorDomain)
            XCTAssertEqual(error.code, NSFileWriteNoPermissionError)
        }
    }

}
