import XCTest
import C7
@testable import PathKit

class ReadWriteTests: BaseTests {

    private func nonExistentPath() -> Path {
        return Path.temporary + UUID.make()
    }

    func testReadData() {
        let path = Path("/etc/manpaths")
        let contents = AssertNoThrow(try path.read())
        let string = AssertNoThrow(try String(data: contents!))

        XCTAssertTrue(string?.hasPrefix("/usr/share/man") == true)
    }

    func testReadNonExistingData() {
        let path = self.nonExistentPath()

        do {
            try path.read()
            XCTFail("Error was not thrown from `read()`")
        } catch Path.ReadWriteError.CouldNotOpenFile {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testReadString() {
        let path = Path("/etc/manpaths")
        let contents = try? path.readString()

        XCTAssertTrue(contents??.hasPrefix("/usr/share/man") ?? false)
    }

    func testReadNonExistingString() {
        let path = self.nonExistentPath()

        do {
            try path.readString()
            XCTFail("Error was not thrown from `readString()`")
        } catch Path.ReadWriteError.CouldNotOpenFile {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWriteData() {
        let path = self.nonExistentPath()
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
        } catch Path.ReadWriteError.CouldNotOpenFile {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWriteString() {
        let path = self.nonExistentPath()

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
        } catch Path.ReadWriteError.CouldNotOpenFile {
            return
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
