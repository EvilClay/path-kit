extension Path {
    /// Test whether a file or directory exists at a specified path
    ///
    /// - Returns: `false` iff the path doesn't exist on disk or its existence could not be
    ///   determined
    ///
    public var exists: Bool {
        #if os(Linux)
            return Path.fileManager.fileExistsAtPath(self.path)
        #else
            return Path.fileManager.fileExists(atPath:self.path)
        #endif
    }

    /// Test whether a path is a directory.
    ///
    /// - Returns: `true` if the path is a directory or a symbolic link that points to a directory;
    ///   `false` if the path is not a directory or the path doesn't exist on disk or its existence
    ///   could not be determined
    ///
    public var isDirectory: Bool {
        var directory = ObjCBool(false)

        #if os(Linux)
            guard Path.fileManager.fileExistsAtPath(normalize().path, isDirectory: &directory) else {
                return false
            }
        #else
            guard Path.fileManager.fileExists(atPath: normalize().path, isDirectory: &directory) else {
                return false
            }
        #endif

        return directory.boolValue
    }

    /// Test whether a path is a regular file.
    ///
    /// - Returns: `true` if the path is neither a directory nor a symbolic link that points to a
    ///   directory; `false` if the path is a directory or a symbolic link that points to a
    ///   directory or the path doesn't exist on disk or its existence
    ///   could not be determined
    ///
    public var isFile: Bool {
        var directory = ObjCBool(false)

        #if os(Linux)
            guard Path.fileManager.fileExistsAtPath(normalize().path, isDirectory: &directory) else {
                return false
            }
        #else
            guard Path.fileManager.fileExists(atPath: normalize().path, isDirectory: &directory) else {
                return false
            }
        #endif

        return !directory.boolValue
    }

    /// Test whether a path is a symbolic link.
    ///
    /// - Returns: `true` if the path is a symbolic link; `false` if the path doesn't exist on disk
    ///   or its existence could not be determined
    ///
    public var isSymlink: Bool {
        do {
            #if os(Linux)
                let _ = try Path.fileManager.destinationOfSymbolicLinkAtPath(path)
            #else
                let _ = try Path.fileManager.destinationOfSymbolicLink(atPath: path)
            #endif

            return true
        } catch {
            return false
        }
    }

    /// Test whether a path is readable
    ///
    /// - Returns: `true` if the current process has read privileges for the file at path;
    ///   otherwise `false` if the process does not have read privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isReadable: Bool {
        #if os(Linux)
            return Path.fileManager.isReadableFileAtPath(self.path)
        #else
            return Path.fileManager.isReadableFile(atPath: self.path)
        #endif
    }

    /// Test whether a path is writeable
    ///
    /// - Returns: `true` if the current process has write privileges for the file at path;
    ///   otherwise `false` if the process does not have write privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isWritable: Bool {
        #if os(Linux)
            return Path.fileManager.isWritableFileAtPath(self.path)
        #else
            return Path.fileManager.isWritableFile(atPath: self.path)
        #endif
    }

    /// Test whether a path is executable
    ///
    /// - Returns: `true` if the current process has execute privileges for the file at path;
    ///   otherwise `false` if the process does not have execute privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isExecutable: Bool {
        #if os(Linux)
            return Path.fileManager.isExecutableFileAtPath(self.path)
        #else
            return Path.fileManager.isExecutableFile(atPath: self.path)
        #endif
    }

    /// Test whether a path is deletable
    ///
    /// - Returns: `true` if the current process has delete privileges for the file at path;
    ///   otherwise `false` if the process does not have delete privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isDeletable: Bool {
        #if os(Linux)
            return Path.fileManager.isDeletableFileAtPath(self.path)
        #else
            return Path.fileManager.isDeletableFile(atPath: self.path)
        #endif
    }

}
