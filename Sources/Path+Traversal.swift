import POSIX

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

            if item.type == Int32(DT_DIR) || (item.type == Int32(DT_UNKNOWN) && path.isDirectory) {
                children += try path.recursiveChildren()
            }
        }

        return children
    }

}
