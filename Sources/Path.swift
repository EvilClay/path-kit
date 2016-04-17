// PathKit - Effortless path operations

import String

/// Represents a filesystem path.
public struct Path {
    /// The character used by the OS to separate two path elements
    public static let separator = "/"

    /// The underlying string representation
    internal var path: String

    // MARK: Init
    public init() {
        self.path = ""
    }

    /// Create a Path from a given String
    public init(_ path: String) {
        self.path = path.trimTrailingSlashes()
    }

    /// Create a Path by joining multiple path components together
    public init<S: Collection where S.Iterator.Element == String>(components: S) {
        if components.isEmpty {
            path = "."
        } else if components.first == Path.separator && components.count > 1 {
            let p = components.joined(separator: Path.separator)
            path = p[p.startIndex.successor()..<p.endIndex]
        } else {
            path = components.joined(separator: Path.separator)
        }
    }

}

// MARK: StringLiteralConvertible

extension Path: StringLiteralConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType

    public init(extendedGraphemeClusterLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }

    public init(unicodeScalarLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }

    public init(stringLiteral value: StringLiteralType) {
        self.path = value
    }

}

// MARK: CustomStringConvertible

extension Path: CustomStringConvertible {
    public var description: String {
        return self.path
    }
}

// MARK: Hashable

extension Path: Hashable {
    public var hashValue: Int {
        return path.hashValue
    }
}

// MARK: Equatable

extension Path: Equatable { }

/// Determines if two paths are identical
///
/// - Note: The comparison is string-based. Be aware that two different paths (foo.txt and
///   ./foo.txt) can refer to the same file.
///
public func ==(lhs: Path, rhs: Path) -> Bool {
    return lhs.path == rhs.path
}

// MARK: Pattern Matching

/// Implements pattern-matching for paths.
///
/// - Returns: `true` iff one of the following conditions is true:
///     - the paths are equal (based on `Path`'s `Equatable` implementation)
///     - the paths can be normalized to equal Paths.
///
public func ~=(lhs: Path, rhs: Path) -> Bool {
    return lhs == rhs || lhs.normalize() == rhs.normalize()
}

// MARK: Comparable

extension Path: Comparable { }

/// Defines a strict total order over Paths based on their underlying string representation.
public func <(lhs: Path, rhs: Path) -> Bool {
    return lhs.path < rhs.path
}

// MARK: Operators

/// Appends a Path fragment to another Path to produce a new Path
public func +(lhs: Path, rhs: Path) -> Path {
    return lhs.path + rhs.path
}

/// Appends a String fragment to another Path to produce a new Path
public func +(lhs: Path, rhs: String) -> Path {
    return lhs.path + rhs
}

/// Appends a String fragment to another String to produce a new Path
internal func +(lhs: String, rhs: String) -> Path {
    if rhs.hasPrefix(Path.separator) {
        // Absolute paths replace relative paths
        return Path(rhs)
    } else {
        var lSlice = lhs.pathComponents.fullSlice
        var rSlice = rhs.pathComponents.fullSlice

        // Get rid of trailing "/" at the left side
        if lSlice.count > 1 && lSlice.last == Path.separator {
            lSlice.removeLast()
        }

        // Advance after the first relevant "."
        lSlice = lSlice.filter { $0 != "." }.fullSlice
        rSlice = rSlice.filter { $0 != "." }.fullSlice

        // Eats up trailing components of the left and leading ".." of the right side
        while lSlice.last != ".." && rSlice.first == ".." {
            if (lSlice.count > 1 || lSlice.first != Path.separator) && !lSlice.isEmpty {
                // A leading "/" is never popped
                lSlice.removeLast()
            }
            if !rSlice.isEmpty {
                rSlice.removeFirst()
            }

            switch (lSlice.isEmpty, rSlice.isEmpty) {
            case (true, _):
                break
            case (_, true):
                break
            default:
                continue
            }
        }

        return Path(components: lSlice + rSlice)
    }

}

extension Array {
    var fullSlice: ArraySlice<Element> {
        return self[0..<self.endIndex]
    }
}

extension String {
    func trimTrailingSlashes() -> String {
        return self == "/" ? self : self.trim(right: ["/"])
    }
}
