import XCTest
import POSIX

@testable import PathKit

class WorkingDirectoryTests: BaseTests {

    private enum TestError: ErrorProtocol {
        case test
    }

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

        do {
            try Path("/usr/bin").chdir {
                XCTAssertEqual(Path.current, Path("/usr/bin"))
                throw TestError.test
            }

            XCTFail("testError should’ve thrown")
        } catch is TestError {
            // Do nothing
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        XCTAssertEqual(Path.current, current)
    }

    func testThrowingChdirWithNonThrowingClosure() {
        let current = Path.current

        AssertNoThrow {
            try Path("/usr/bin").chdir {
                XCTAssertEqual(Path.current, Path("/usr/bin"))
                if Path.current != Path("/usr/bin") {
                    // Will never happen as long as the previous assert succeeds,
                    // but prevents a warning that the closure doesn't throw.
                    throw TestError.test
                }
            }
        }

        XCTAssertEqual(Path.current, current)
    }

}

extension WorkingDirectoryTests {
    static var allTests: [(String, WorkingDirectoryTests -> () throws -> Void)] {
        return [
            ("testCurrent", testCurrent),
            ("testChdir", testChdir),
            ("testThrowingChdirWithThrowingClosure", testThrowingChdirWithThrowingClosure),
            ("testThrowingChdirWithNonThrowingClosure", testThrowingChdirWithNonThrowingClosure),
        ]
    }
}
