import POSIX

extension Path {
    /// The current working directory of the process
    ///
    /// - Returns: the current working directory of the process
    ///
    public static var current: Path? {
        get {
            let cwd = getcwd(nil, Int(PATH_MAX))

            guard cwd != nil else {
                return nil
            }

            defer { free(cwd) }

            guard let path = String(validatingUTF8: cwd) else {
                return nil
            }

            return self.init(path)
        }

        set {
            guard let newValue = newValue?.path else {
                return
            }

            POSIX.chdir(newValue)
        }
    }

    /// Changes the current working directory of the process to the path during the execution of the
    /// given block.
    ///
    /// - Note: The original working directory is restored when the block returns or throws.
    /// - Parameter closure: A closure to be executed while the current directory is configured to
    ///   the path.
    ///
    public func chdir(@noescape closure: () throws -> ()) rethrows {
        let previous = Path.current
        Path.current = self
        defer { Path.current = previous }
        try closure()
    }

}
