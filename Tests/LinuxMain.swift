#if os(Linux)

import XCTest
@testable import PathKitTestSuite

XCTMain([
    testCase(ComponentsTests.allTests),
    testCase(FileInfoTests.allTests),
    testCase(FileManipulationTests.allTests),
    testCase(GlobTests.allTests),
    testCase(InfoTests.allTests),
    testCase(PathTests.allTests),
    testCase(ReadWriteTests.allTests),
    testCase(SequenceTests.allTests),
    testCase(TemporaryTests.allTests),
    testCase(TraversalTests.allTests),
    testCase(WorkingDirectoryTests.allTests),
])

#endif
