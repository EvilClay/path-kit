import OperatingSystem

extension Path {

    enum FileError: ErrorProtocol {
        case unimplemented
        case mkdir(Int, String)
        case move(Int, String, String)
        case copy(Int, String, String)
        case delete(Int, String)
        case symlink(Int, String, String)
        case notFound(String)
    }

    /// Create the directory.
    ///
    /// - Note: This method fails if any of the intermediate parent directories does not exist.
    ///   This method also fails if any of the intermediate path elements corresponds to a file and
    ///   not a directory.
    ///
    public func mkdir() throws {
        let result = OperatingSystem.mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO)

        if result != 0 && result != EEXIST {
            throw FileError.mkdir(Int(errno), path)
        }
    }

    /// Create the directory and any intermediate parent directories that do not exist.
    ///
    /// - Note: This method fails if any of the intermediate path elements corresponds to a file and
    ///   not a directory.
    ///
    public func mkpath() throws {
        var path = ""

        for (i, component) in components.enumerated() {
            if i == 0 {
                path = component
            } else {
                guard component != "/" else {
                    continue
                }

                path += "/" + component
            }

            let result = OperatingSystem.mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO)

            if result != 0 && result != EEXIST {
                throw FileError.mkdir(Int(errno), path)
            }
        }
    }

    /// Delete the file or directory.
    ///
    /// - Note: If the path specifies a directory, the contents of that directory are recursively
    ///   removed.
    ///
    public func delete() throws {
        let result = nftw(path, { (path, sb, typeflag, ftw) -> Int32 in
            let result = remove(path)

            if result != 0 {
                perror(path)
            }

            return result
        }, 64, FTW_DEPTH | FTW_PHYS)

        if result != 0 {
            throw FileError.delete(Int(errno), path)
        }
    }

    /// Move the file or directory to a new location synchronously.
    ///
    /// - Parameter destination: The new path. This path must include the name of the file or
    ///   directory in its new location.
    ///
    public func move(destination: Path) throws {
        let result = rename(path, destination.path)

        if result != 0 {
            throw FileError.move(Int(errno), path, destination.path)
        }
    }

    /// Copy the file or directory to a new location synchronously.
    ///
    /// - Parameter destination: The new path. This path must include the name of the file or
    ///   directory in its new location.
    ///
    public func copy(destination: Path) throws {
        let info = StatInfo(path: self)

        guard info.exists else {
            throw FileError.notFound(path)
        }

        var flags = COPYFILE_ACL | COPYFILE_STAT | COPYFILE_XATTR | COPYFILE_DATA

        if info.directory {
            flags |= COPYFILE_RECURSIVE
        }

        let result = copyfile(path, destination.path, nil, copyfile_flags_t(flags))

        if result != 0 {
            throw FileError.copy(Int(errno), path, destination.path)
        }
    }

    /// Creates a hard link at a new destination.
    ///
    /// - Parameter destination: The location where the link will be created.
    ///
    public func link(destination: Path) throws {
        // TODO
        throw FileError.unimplemented
    }

    /// Creates a symbolic link at a new destination.
    ///
    /// - Parameter destintation: The location where the link will be created.
    ///
    public func symlink(destination: Path) throws {
        let result = OperatingSystem.symlink(destination.path, path)

        if result != 0 {
            throw FileError.symlink(Int(errno), path, destination.path)
        }
    }

}
