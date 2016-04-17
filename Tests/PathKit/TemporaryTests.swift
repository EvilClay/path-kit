import XCTest
@testable import PathKit

class TemporaryTests: BaseTests {

    func testHomeDir() {
        XCTAssertEqual(Path.home, Path("~").normalize())
    }

    func testTemporaryDir() {
        // No good way to test this off of OS X
        // XCTAssertEqual((Path.temporary + "../../..").normalize(), Path("/var/folders"))

        XCTAssertTrue(Path.temporary.exists)
    }

}
