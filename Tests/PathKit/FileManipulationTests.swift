import XCTest
@testable import PathKit

class ManipulationTests: BaseTests {

    var fixtureFile: Path {
        return fixtures + "file"
    }

    var copiedFile: Path {
        let path = Path("file")

        if !path.exists {
            AssertNoThrow({
                try fixtureFile.copy(path)
            })
        }

        return path
    }

    override func setUp() {
        super.setUp()

        Path.current = try! Path.uniqueTemporary()
    }

    override func tearDown() {
        super.tearDown()

        try! Path.current?.delete()
    }

    func testMkdir() {
        let testDir = Path("test_mkdir")
        AssertNoThrow { try testDir.mkdir() }
        XCTAssertTrue(testDir.isDirectory)
    }

    func testMkdirWithNonExistingImmediateDirFails() {
        let testDir = Path("test_mkdir/test")

        do {
            try testDir.mkdir()
            XCTFail("\(#function) did not throw an error)")
        } catch Path.FileError.mkdir {
            return
        } catch {
            XCTFail("\(#function) threw unexpected error: \(error))")
        }
    }

    func testMkdirWithExistingDirFails() {
        let testDir = Path("test_mkdir")
        AssertNoThrow {
            try testDir.mkdir()
            precondition(testDir.isDirectory)

            do {
                try testDir.mkdir()
                XCTFail("\(#function) did not throw an error)")
            } catch Path.FileError.mkdir {
                return
            } catch {
                XCTFail("\(#function) threw unexpected error: \(error))")
            }
        }
    }

    func testMkpath() {
        let testDir = Path("test_mkpath/test")
        AssertNoThrow {
            try testDir.mkpath()
            XCTAssertTrue(testDir.isDirectory)
        }
    }

    func testMkpathWithExistingDir() {
        let testDir = Path("test_mkdir")
        AssertNoThrow {
            try testDir.mkdir()
            precondition(testDir.isDirectory)
            try testDir.mkpath()
        }
    }

    func testCopy() {
        let copiedFile = Path("file")
        AssertNoThrow {
            try fixtureFile.copy(copiedFile)
            XCTAssertTrue(copiedFile.isFile)
        }
    }

    func testMove() {
        let movedFile = Path("moved")
        AssertNoThrow {
            try copiedFile.move(movedFile)
            XCTAssertTrue(movedFile.isFile)
        }
    }

    func testLink() {
        let linkedFile = Path("linked")
        AssertNoThrow {
            try copiedFile.link(linkedFile)
            XCTAssertTrue(linkedFile.isFile)
        }
    }

    func testSymlink() {
        let symlinkedFile = Path("symlinked")
        AssertNoThrow {
            try symlinkedFile.symlink(copiedFile)
            XCTAssertTrue(symlinkedFile.isFile)
            let symlinkDestination = try symlinkedFile.symlinkDestination()
            XCTAssertEqual(symlinkDestination, copiedFile.absolute())
        }
    }

    func testRelativeSymlinkDestination() {
        let path = fixtures + "symlinks/file"
        AssertNoThrow {
            let resolvedPath = try path.symlinkDestination()
            XCTAssertEqual(resolvedPath.normalize(), fixtures + "file")
        }
    }

    func testAbsoluteSymlinkDestination() {
        let path = fixtures + "symlinks/swift"
        AssertNoThrow {
            let resolvedPath = try path.symlinkDestination()
            XCTAssertEqual(resolvedPath, Path("/usr/bin/swift"))
        }
    }

    func testRelativeSymlinkDestinationInSameDirectory() {
        let path = fixtures + "symlinks/same-dir"
        AssertNoThrow {
            let resolvedPath = try path.symlinkDestination()
            XCTAssertEqual(resolvedPath.normalize(), fixtures + "symlinks/file")
        }
    }

}
