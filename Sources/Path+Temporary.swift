extension Path {
    /// - Returns: the path to either the user’s or application’s home directory,
    ///   depending on the platform.
    ///
    public static var home: Path {
        return Path(getenv(named: "HOME") ?? "/")
    }

    /// - Returns: the path of the temporary directory for the current user.
    ///
    public static var temporary: Path {
        return Path(getenv(named: "TMP") ?? "/")
    }

    /// - Returns: the path of a temporary directory unique for the process.
    /// - Note: Based on `NSProcessInfo.globallyUniqueString`.
    ///
    public static func processUniqueTemporary() throws -> Path {
        let path = temporary + NSProcessInfo.processInfo().globallyUniqueString

        if !path.exists {
            try path.mkdir()
        }

        return path
    }

    /// - Returns: the path of a temporary directory unique for each call.
    /// - Note: Based on `NSUUID`.
    ///
    public static func uniqueTemporary() throws -> Path {
        #if os(Linux)
            let path = try processUniqueTemporary() + NSUUID().UUIDString
        #else
            let path = try processUniqueTemporary() + NSUUID().uuidString
        #endif

        try path.mkdir()
        return path
    }

}
