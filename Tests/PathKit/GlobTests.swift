import XCTest
@testable import PathKit

class GlobTests: BaseTests {

    func testStaticGlob() {
        AssertNoThrow {
            let pattern = (fixtures + "permissions/*able").description
            let paths = Path.glob(pattern)

            let results = try (fixtures + "permissions").children().map { $0.absolute()! }
            XCTAssertEqual(paths, results)
        }
    }

    func testPathGlob() {
        AssertNoThrow {
            let paths = fixtures.glob("permissions/*able")

            let results = try (fixtures + "permissions").children().map { $0.absolute()! }
            XCTAssertEqual(paths, results)
        }
    }

}
