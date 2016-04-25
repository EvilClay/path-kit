import POSIX

#if os(Linux)
    typealias UnsafeDir = OpaquePointer
#else
    typealias UnsafeDir = UnsafeMutablePointer<DIR>
#endif

internal class DirectoryIterator: IteratorProtocol {
    typealias Element = (name: String, type: Int32?)

    private let dir: UnsafeDir
    internal let path: Path

    init(path: Path) throws {
        let dir = opendir(path.path)

        guard dir != nil else {
            throw Path.TraversalError.opendir(Int(errno))
        }

        self.dir = dir
        self.path = path
    }

    func next() -> Element? {
        let entry = readdir(dir)

        guard entry != nil else {
            return nil
        }

        guard let name = withUnsafePointer(&entry.pointee.d_name, { (ptr) -> String? in
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<Int8>.self)
            return String(cString: int8Ptr)
        }) else {
            return nil
        }

        guard name != "." && name != ".." else {
            return next()
        }

        let type = withUnsafePointer(&entry.pointee.d_type, { (ptr) -> Int32? in
            let int32Ptr = unsafeBitCast(ptr, to: UnsafePointer<UInt8>.self)
            return Int32(int32Ptr.pointee)
        })

        return (name, type)
    }

    deinit {
        closedir(dir)
    }

}
