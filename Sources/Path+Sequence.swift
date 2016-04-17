import OperatingSystem

extension Path: Sequence {
    /// Enumerates the contents of a directory, returning the paths of all files and directories
    /// contained within that directory.
    public class DirectoryEnumerator: IteratorProtocol {
        public typealias Element = Path

        private let path: Path
        private var iterators = [DirectoryIterator]()

        init(path: Path) {
            self.path = path
            appendIterator(for: path)
        }

        public func next() -> Path? {
            guard let iterator = iterators.last else {
                return nil
            }

            guard let element = iterator.next() else {
                iterators.removeLast()
                return next()
            }

            let path = Path(iterator.path.path + element.name)

            if element.type == DT_DIR {
                appendIterator(for: path)
            }

            return path
        }

        public func skipDescendants() {
            iterators.removeLast()
        }

        private func appendIterator(for path: Path) {
            do {
                let iterator = try DirectoryIterator(path: path)
                iterators.append(iterator)
            } catch {
                print("Error opening: \(path): \(error)")
            }
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
