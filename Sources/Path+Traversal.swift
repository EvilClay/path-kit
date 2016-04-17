import OperatingSystem

extension Path {

    enum TraversalError: ErrorProtocol {
        case opendir(Int)
    }

    /// Get the parent directory
    ///
    /// - Returns: the normalized path of the parent directory
    ///
    public func parent() -> Path {
        return path + ".."
    }

    /// Performs a shallow enumeration in a directory
    ///
    /// - Returns: paths to all files, directories and symbolic links contained in the directory
    ///
    public func children() throws -> [Path] {
        let iterator = try DirectoryIterator(path: self)
        var children = [Path]()

        while let item = iterator.next() {
            children.append(self + Path(item.name))
        }

        return children
    }

    /// Performs a deep enumeration in a directory
    ///
    /// - Returns: paths to all files, directories and symbolic links contained in the directory or
    ///   any subdirectory.
    ///
    public func recursiveChildren() throws -> [Path] {
        let iterator = try DirectoryIterator(path: self)
        var children = [Path]()

        while let item = iterator.next() {
            let path = self + Path(item.name)
            children.append(path)

            if item.type == DT_DIR {
                children += try path.recursiveChildren()
            }
        }

        return children
    }

}

private func read(dir: UnsafeMutablePointer<DIR>, handler: (name: String, type: Int32?) throws -> Void) throws {
    var entry = readdir(dir)

    while entry != nil {
        let name = withUnsafePointer(&entry.pointee.d_name, { (ptr) -> String? in
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<Int8>.self)
            return String(cString: int8Ptr)
        })

        if let name = name where name != "." && name != ".." {
            let type = withUnsafePointer(&entry.pointee.d_type, { (ptr) -> Int32? in
                let int32Ptr = unsafeBitCast(ptr, to: UnsafePointer<UInt8>.self)
                return Int32(int32Ptr.pointee)
            })

            try handler(name: name, type: type)
        }

        entry = readdir(dir)
    }
}
