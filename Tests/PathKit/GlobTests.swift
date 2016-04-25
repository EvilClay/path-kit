import XCTest
@testable import PathKit

class GlobTests: BaseTests {

    func testStaticGlob() {
        AssertNoThrow {
            let pattern = (fixtures + "permissions/*able").description
            let paths = Path.glob(pattern: pattern)

            let results = try (fixtures + "permissions").children().map { $0.absolute()! }
            XCTAssertEqual(paths.sorted(), results.sorted())
        }
    }

    func testPathGlob() {
        AssertNoThrow {
            let paths = fixtures.glob(pattern: "permissions/*able")

            let results = try (fixtures + "permissions").children().map { $0.absolute()! }
            XCTAssertEqual(paths.sorted(), results.sorted())
        }
    }

}

extension GlobTests {
    static var allTests: [(String, GlobTests -> () throws -> Void)] {
        return [
            ("testStaticGlob", testStaticGlob),
            ("testPathGlob", testPathGlob),
        ]
    }
}
