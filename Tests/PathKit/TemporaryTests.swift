import XCTest
@testable import PathKit

class TemporaryTests: BaseTests {

    func testHomeDir() {
        XCTAssertEqual(Path.home, Path("~").normalize())
    }

    func testTemporaryDir() {
        XCTAssertEqual((Path.temporary + "../../..").normalize(), Path("/var/folders"))
        XCTAssertTrue(Path.temporary.exists)
    }

}
