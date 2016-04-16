extension Path: Sequence {
    /// Enumerates the contents of a directory, returning the paths of all files and directories
    /// contained within that directory. These paths are relative to the directory.
    public struct DirectoryEnumerator: IteratorProtocol {
        public typealias Element = Path

        let path: Path
        let directoryEnumerator: NSDirectoryEnumerator

        init(path: Path) {
            self.path = path

            #if os(Linux)
                self.directoryEnumerator = Path.fileManager.enumeratorAtPath(path.path)!
            #else
                self.directoryEnumerator = Path.fileManager.enumerator(atPath:path.path)!
            #endif
        }

        public func next() -> Path? {
            if let next = directoryEnumerator.nextObject() as! String? {
                return path + next
            }
            return nil
        }

        /// Skip recursion into the most recently obtained subdirectory.
        public func skipDescendants() {
            directoryEnumerator.skipDescendants()
        }
    }

    /// Perform a deep enumeration of a directory.
    ///
    /// - Returns: a directory enumerator that can be used to perform a deep enumeration of the
    ///   directory.
    ///
    public func makeIterator() -> DirectoryEnumerator {
        return DirectoryEnumerator(path: self)
    }

}
