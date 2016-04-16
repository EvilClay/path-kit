extension Path {
    /// Create the directory.
    ///
    /// - Note: This method fails if any of the intermediate parent directories does not exist.
    ///   This method also fails if any of the intermediate path elements corresponds to a file and
    ///   not a directory.
    ///
    public func mkdir() throws -> () {
        #if os(Linux)
            try Path.fileManager.createDirectoryAtPath(self.path, withIntermediateDirectories: false, attributes: nil)
        #else
            try Path.fileManager.createDirectory(atPath: self.path, withIntermediateDirectories: false, attributes: nil)
        #endif
    }

    /// Create the directory and any intermediate parent directories that do not exist.
    ///
    /// - Note: This method fails if any of the intermediate path elements corresponds to a file and
    ///   not a directory.
    ///
    public func mkpath() throws -> () {
        #if os(Linux)
            try Path.fileManager.createDirectoryAtPath(self.path, withIntermediateDirectories: true, attributes: nil)
        #else
            try Path.fileManager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
        #endif
    }

    /// Delete the file or directory.
    ///
    /// - Note: If the path specifies a directory, the contents of that directory are recursively
    ///   removed.
    ///
    public func delete() throws -> () {
        #if os(Linux)
            try Path.fileManager.removeItemAtPath(self.path)
        #else
            try Path.fileManager.removeItem(atPath: self.path)
        #endif
    }

    /// Move the file or directory to a new location synchronously.
    ///
    /// - Parameter destination: The new path. This path must include the name of the file or
    ///   directory in its new location.
    ///
    public func move(destination: Path) throws -> () {
        #if os(Linux)
            try Path.fileManager.moveItemAtPath(self.path, toPath: destination.path)
        #else
            try Path.fileManager.moveItem(atPath: self.path, toPath: destination.path)
        #endif
    }

    /// Copy the file or directory to a new location synchronously.
    ///
    /// - Parameter destination: The new path. This path must include the name of the file or
    ///   directory in its new location.
    ///
    public func copy(destination: Path) throws -> () {
        #if os(Linux)
            try Path.fileManager.copyItemAtPath(self.path, toPath: destination.path)
        #else
            try Path.fileManager.copyItem(atPath: self.path, toPath: destination.path)
        #endif
    }

    /// Creates a hard link at a new destination.
    ///
    /// - Parameter destination: The location where the link will be created.
    ///
    public func link(destination: Path) throws -> () {
        #if os(Linux)
            try Path.fileManager.linkItemAtPath(self.path, toPath: destination.path)
        #else
            try Path.fileManager.linkItem(atPath: self.path, toPath: destination.path)
        #endif
    }

    /// Creates a symbolic link at a new destination.
    ///
    /// - Parameter destintation: The location where the link will be created.
    ///
    public func symlink(destination: Path) throws -> () {
        #if os(Linux)
            try Path.fileManager.createSymbolicLinkAtPath(self.path, withDestinationPath: destination.path)
        #else
            try Path.fileManager.createSymbolicLink(atPath: self.path, withDestinationPath: destination.path)
        #endif
    }

}
