import OperatingSystem

extension Path {
    private static let processUUID = UUID.make()

    /// - Returns: the path to either the user’s or application’s home directory,
    ///   depending on the platform.
    public static var home: Path {
        return Path(getenv(named: "HOME") ?? "/")
    }

    /// - Returns: the path of the temporary directory for the current user.
    public static var temporary: Path {
        return Path(getenv(named: "TMP") ?? "/")
    }

    /// - Returns: the path of a temporary directory unique for the process.
    public static func processUniqueTemporary() throws -> Path {
        let path = temporary + processUUID

        if !path.exists {
            try path.mkdir()
        }

        return path
    }

    /// - Returns: the path of a temporary directory unique for each call.
    public static func uniqueTemporary() throws -> Path {
        let path = try processUniqueTemporary() + UUID.make()
        try path.mkdir()
        return path
    }

}
