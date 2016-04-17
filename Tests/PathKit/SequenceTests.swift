import XCTest
@testable import PathKit

class SequenceTests: BaseTests {

    func testSequenceType() {
        let path = fixtures + "directory"
        var children = ["child", "subdirectory"].map { path + $0 }
        let generator = path.makeIterator()
        while let child = generator.next() {
            generator.skipDescendants()
            if let index = children.index(of: child) {
                children.remove(at: index)
            } else {
                XCTFail("Generated unexpected element: <\(child)>")
            }
        }
        XCTAssertTrue(children.isEmpty)
    }

}
