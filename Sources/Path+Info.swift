import String

extension Path {

    enum InfoError: ErrorProtocol {
        case realpath(Int)
    }

    /// Test whether a path is absolute.
    ///
    /// - Returns: `true` iff the path begings with a slash
    ///
    public var isAbsolute: Bool {
        return path.hasPrefix(Path.separator)
    }

    /// Test whether a path is relative.
    ///
    /// - Returns: `true` iff a path is relative (not absolute)
    ///
    public var isRelative: Bool {
        return !isAbsolute
    }

    /// Concatenates relative paths to the current directory and derives the normalized path
    ///
    /// - Returns: the absolute path in the actual filesystem
    ///
    public func absolute() -> Path? {
        if isAbsolute {
            return normalize()
        }

        guard let current = self.dynamicType.current else {
            return nil
        }

        return (current + self).normalize()
    }

    internal func expandTilde() -> Path {
        guard path.hasPrefix("~") else {
            return self
        }

        var components = self.components
        components.removeFirst()

        return Path(components: Path.home.components + components)
    }

    /// Normalizes the path, this cleans up redundant ".." and ".", double slashes
    /// and resolves "~".
    ///
    /// - Returns: a new path made by removing extraneous path components from the underlying String
    ///   representation.
    ///
    public func normalize() -> Path {
        let components = self.expandTilde().components
        var normalized = [String]()

        for (i, component) in components.enumerated() {
            guard component != "." else {
                continue
            }

            guard component != "/" || i == 0 else {
                continue
            }

            if component == ".." {
                normalized.removeLast()
            } else {
                normalized.append(component)
            }
        }

        return Path(components: normalized)
    }

    /// De-normalizes the path, by replacing the current user home directory with "~".
    ///
    /// - Returns: a new path made by removing extraneous path components from the underlying String
    ///   representation.
    ///
    public func abbreviate() -> Path {
        guard let home = getenv(named: "HOME")?.trimTrailingSlashes() where home.characters.count > 0 else {
            return self
        }

        let normalized = self.normalize().path

        guard normalized.hasPrefix(home) else {
            return self
        }

        return Path("~" + normalized[normalized.startIndex.advanced(by: home.characters.count)..<normalized.endIndex])
    }

    /// Returns the path of the item pointed to by a symbolic link.
    ///
    /// - Returns: the path of directory or file to which the symbolic link refers
    ///
    public func symlinkDestination() throws -> Path {
        let result = realpath(path, nil)

        guard result != nil else {
            throw InfoError.realpath(Int(errno))
        }

        defer {
            free(result)
        }

        guard let path = String(validatingUTF8: result) else {
            throw InfoError.realpath(-1)
        }

        return Path(path)
    }

}
