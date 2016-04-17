import XCTest
import C7
@testable import PathKit

class ReadWriteTests: BaseTests {

    private func nonExistentPath() -> Path {
        return Path.temporary + UUID.make()
    }

    func testReadData() {
        let path = fixtures + "read"

        guard let contents = AssertNoThrow(try path.read()) else {
            XCTFail("Could not read \(path)")
            return
        }

        let string = AssertNoThrow(try String(data: contents))

        XCTAssertTrue(string == "hello")
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
        let path = fixtures + "read"
        let contents = (try? path.readString()) ?? nil

        XCTAssertTrue(contents == "hello")
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

extension ReadWriteTests {
    static var allTests: [(String, ReadWriteTests -> () throws -> Void)] {
        return [
            ("testReadData", testReadData),
            ("testReadNonExistingData", testReadNonExistingData),
            ("testReadString", testReadString),
            ("testReadNonExistingString", testReadNonExistingString),
            ("testWriteData", testWriteData),
            ("testWriteDataThrowsOnFailure", testWriteDataThrowsOnFailure),
            ("testWriteString", testWriteString),
            ("testWriteStringThrowsOnFailure", testWriteStringThrowsOnFailure),
        ]
    }
}
