extension Path {
    /// Get the parent directory
    ///
    /// - Returns: the normalized path of the parent directory
    ///
    public func parent() -> Path {
        return self + ".."
    }

    /// Performs a shallow enumeration in a directory
    ///
    /// - Returns: paths to all files, directories and symbolic links contained in the directory
    ///
    public func children() throws -> [Path] {
        #if os(Linux)
            return try Path.fileManager.contentsOfDirectoryAtPath(path).map {
                self + Path($0)
            }
        #else
            return try Path.fileManager.contentsOfDirectory(atPath:path).map {
                self + Path($0)
            }
        #endif
    }

    /// Performs a deep enumeration in a directory
    ///
    /// - Returns: paths to all files, directories and symbolic links contained in the directory or
    ///   any subdirectory.
    ///
    public func recursiveChildren() throws -> [Path] {
        #if os(Linux)
            return try Path.fileManager.subpathsOfDirectoryAtPath(path).map {
                self + Path($0)
            }
        #else
            return try Path.fileManager.subpathsOfDirectory(atPath:path).map {
                self + Path($0)
            }
        #endif
    }

}
