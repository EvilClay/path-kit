import OperatingSystem

extension Path {

    /// Test whether a file or directory exists at a specified path
    ///
    /// - Returns: `false` iff the path doesn't exist on disk or its existence could not be
    ///   determined
    ///
    public var exists: Bool {
		return StatInfo(path: self).exists
    }

    /// Test whether a path is a directory.
    ///
    /// - Returns: `true` if the path is a directory or a symbolic link that points to a directory;
    ///   `false` if the path is not a directory or the path doesn't exist on disk or its existence
    ///   could not be determined
    ///
    public var isDirectory: Bool {
		return StatInfo(path: self).directory
    }

    /// Test whether a path is a regular file.
    ///
    /// - Returns: `true` if the path is neither a directory nor a symbolic link that points to a
    ///   directory; `false` if the path is a directory or a symbolic link that points to a
    ///   directory or the path doesn't exist on disk or its existence
    ///   could not be determined
    ///
    public var isFile: Bool {
		let statInfo = StatInfo(path: self)
		return statInfo.exists && !statInfo.directory
    }

    /// Test whether a path is a symbolic link.
    ///
    /// - Returns: `true` if the path is a symbolic link; `false` if the path doesn't exist on disk
    ///   or its existence could not be determined
    ///
    public var isSymlink: Bool {
		return StatInfo(path: self).link
    }

    /// Test whether a path is readable
    ///
    /// - Returns: `true` if the current process has read privileges for the file at path;
    ///   otherwise `false` if the process does not have read privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isReadable: Bool {
		return access(path, R_OK) == 0
    }

    /// Test whether a path is writeable
    ///
    /// - Returns: `true` if the current process has write privileges for the file at path;
    ///   otherwise `false` if the process does not have write privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isWritable: Bool {
		return access(path, W_OK) == 0
    }

    /// Test whether a path is executable
    ///
    /// - Returns: `true` if the current process has execute privileges for the file at path;
    ///   otherwise `false` if the process does not have execute privileges or the existence of the
    ///   file could not be determined.
    ///
    public var isExecutable: Bool {
		return access(path, X_OK) == 0
    }

}
