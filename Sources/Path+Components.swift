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
    public var lastComponentWithoutExtension: String? {
        guard let component = self.lastComponent, extensionIndex = component.extensionIndex else {
            return nil
        }

        guard extensionIndex != component.startIndex && extensionIndex.predecessor() != component.startIndex else {
            return nil
        }

        return component[component.startIndex..<extensionIndex.predecessor()]
    }

    /// Splits the string representation on the directory separator.
    /// Absolute paths remain the leading slash as first component.
    ///
    /// - Returns: all path components
    ///
    public var components: [String] {
        return path.pathComponents
    }

    /// The file extension behind the last dot of the last component.
    ///
    /// - Returns: the file extension
    ///
    public var `extension`: String? {
        guard let extensionIndex = path.extensionIndex else {
            return nil
        }

        return path[extensionIndex..<path.endIndex]
    }

}

extension String {

    internal var pathComponents: [String] {
        var components = self.trimTrailingSlashes().split(separator: Character(Path.separator))

        if self.starts(with: "/") {
            components.insert("/", at: 0)
        }

        return components
    }

    private var extensionIndex: String.Index? {
        let characters = self.characters
        let startIndex = characters.startIndex
        var currentIndex = characters.endIndex

        while currentIndex > startIndex {
            let previousIndex = currentIndex.predecessor()
            let char = characters[previousIndex]

            guard char != "/" else {
                return nil
            }

            guard char == "." else {
                currentIndex = previousIndex
                continue
            }

            if startIndex == previousIndex {
                return nil
            } else {
                return currentIndex
            }
        }

        return nil
    }

}
