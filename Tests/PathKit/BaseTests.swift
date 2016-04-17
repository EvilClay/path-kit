import XCTest
import C7
@testable import PathKit

class BaseTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Path.current = Path(#file).parent()
    }

    var fixtures: Path {
        return (Path(#file) + "../../../Fixtures")
    }

}

func AssertNoThrow<R>(@autoclosure closure: () throws -> R) -> R? {
    var result: R?
    AssertNoThrow() {
        result = try closure()
    }
    return result
}

func AssertNoThrow(@noescape closure: () throws -> ()) {
    do {
        try closure()
    } catch let error {
        XCTFail("Caught unexpected error <\(error)>.")
    }
}
