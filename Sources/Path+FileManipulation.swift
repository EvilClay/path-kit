import OperatingSystem

extension Path {

    enum FileError: ErrorProtocol {
        case mkdir(Int, String)
        case move(Int, String, String)
        case copy(Int, String, String)
        case delete(Int, String)
        case link(Int, String, String)
        case symlink(Int, String, String)
        case notFound(String)
        case unimplemented(String)
    }

    /// Create the directory.
    ///
    /// - Note: This method fails if any of the intermediate parent directories does not exist.
    ///   This method also fails if any of the intermediate path elements corresponds to a file and
    ///   not a directory.
    ///
    public func mkdir() throws {
        let result = OperatingSystem.mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO)

        if result != 0 {
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

            if result != 0 && errno != EEXIST {
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
        try self.delete(with: StatInfo(path: self))
    }

    private func delete(with info: StatInfo) throws {
        let result: Int32

        if info.directory {
            let iterator = try DirectoryIterator(path: self)

            while let element = iterator.next() {
                let child: Path = iterator.path.path + element.name
                let info = StatInfo(path: child)

                guard !info.directory || !info.link else {
                    continue
                }

                try child.delete(with: info)
            }

            result = remove(path)
        } else {
            result = remove(path)
        }

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

        if info.directory {
            try self.copyDirectory(to: destination, with: info)
        } else {
            try self.copyFile(to: destination, with: info)
        }
    }

    private func copyFile(to destination: Path, with info: StatInfo) throws {
        let input = open(path, O_RDONLY)

        guard input >= 0 else {
            throw ReadWriteError.CouldNotOpenFile(path)
        }

        defer {
            close(input)
        }

        let output = open(destination.path, O_RDWR | O_CREAT)

        guard output >= 0 else {
            throw ReadWriteError.CouldNotOpenFile(destination.path)
        }

        defer {
            close(output)
        }

        var result = Int32(0)

        #if os(Linux)
            let chunkSize = 4096
            var buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(allocatingCapacity: chunkSize)
            defer { buffer.deinitialize() }

            while true {
                var nread = OperatingSystem.read(input, &buffer, chunkSize)

                if nread <= 0 {
                    break
                }

                var nwritten = 0

                repeat {
                    nwritten = OperatingSystem.write(output, buffer, nread)

                    if nwritten >= 0 {
                        nread -= nwritten
                        buffer += nwritten
                    } else if errno != EINTR {
                        result = -1
                        break
                    }
                } while (nread > 0)
            }
        #else
            let flags = COPYFILE_ACL | COPYFILE_STAT | COPYFILE_XATTR | COPYFILE_DATA
            result = fcopyfile(input, output, nil, copyfile_flags_t(flags))
        #endif

        if result != 0 {
            throw FileError.copy(Int(errno), path, destination.path)
        }
    }

    private func copyDirectory(to destination: Path, with info: StatInfo) throws {
        #if os(Linux)
            throw FileError.unimplemented("Copying directories is not supported on Linux")
        #else
            let flags = COPYFILE_ACL | COPYFILE_STAT | COPYFILE_XATTR | COPYFILE_DATA | COPYFILE_RECURSIVE
            let result = copyfile(path, destination.path, nil, copyfile_flags_t(flags))

            if result != 0 {
                throw FileError.copy(Int(errno), path, destination.path)
            }
        #endif
    }

    /// Creates a hard link at a new destination.
    ///
    /// - Parameter destination: The location where the link will be created.
    ///
    public func link(destination: Path) throws {
        let result = OperatingSystem.link(path, destination.path)

        if result != 0 {
            throw FileError.link(Int(errno), path, destination.path)
        }
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
