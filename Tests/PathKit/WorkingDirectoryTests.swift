import XCTest
@testable import PathKit

class WorkingDirectoryTests: BaseTests {

    func testCurrent() {
        let path = Path.current
        XCTAssertEqual(path?.description, String(validatingUTF8: getcwd(nil, Int(PATH_MAX))))
    }

    func testChdir() {
        let current = Path.current

        Path("/usr/bin").chdir {
            XCTAssertEqual(Path.current, Path("/usr/bin"))
        }

        XCTAssertEqual(Path.current, current)
    }

    func testThrowingChdirWithThrowingClosure() {
        let current = Path.current

        let testError = NSError(domain: "org.cocode.PathKit", code: 1, userInfo: nil)

        do {
            try Path("/usr/bin").chdir {
                XCTAssertEqual(Path.current, Path("/usr/bin"))
                throw testError
            }

            XCTFail("testError should’ve thrown")
        } catch {
            XCTAssertEqual(error as NSError, testError)
        }

        XCTAssertEqual(Path.current, current)
    }

    func testThrowingChdirWithNonThrowingClosure() {
        let current = Path.current

        let error = NSError(domain: "org.cocode.PathKit", code: 1, userInfo: nil)
        AssertNoThrow {
            try Path("/usr/bin").chdir {
                XCTAssertEqual(Path.current, Path("/usr/bin"))
                if Path.current != Path("/usr/bin") {
                    // Will never happen as long as the previous assert succeeds,
                    // but prevents a warning that the closure doesn't throw.
                    throw error
                }
            }
        }

        XCTAssertEqual(Path.current, current)
    }

}
