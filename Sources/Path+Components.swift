extension Path {
    /// The last path component
    ///
    /// - Returns: the last path component
    ///
    public var lastComponent: String? {
        return components.last
    }

    /// The last path component without file extension
    ///
    /// - Note: This returns "." for "..".
    ///
    /// - Returns: the last path component without file extension
    ///
    public var lastComponentWithoutExtension: String {
        #if os(Linux)
            return NSString(string: lastComponent).stringByDeletingPathExtension
        #else
            return NSString(string: lastComponent).deletingPathExtension
        #endif
    }

    /// Splits the string representation on the directory separator.
    /// Absolute paths remain the leading slash as first component.
    ///
    /// - Returns: all path components
    ///
    public var components: [String] {
        var components = path.split(by: Path.separator)

        if components.first == "" {
            components[0] = Path.separator
        }

        return components
    }

    /// The file extension behind the last dot of the last component.
    ///
    /// - Returns: the file extension
    ///
    public var `extension`: String? {
        let pathExtension = NSString(string: path).pathExtension
        if pathExtension.isEmpty {
            return nil
        }

        return pathExtension
    }

}
