import OperatingSystem

extension Path {
    public static func glob(pattern: String) -> [Path] {
        var gt = glob_t()
        let cPattern = strdup(pattern)
        defer {
            globfree(&gt)
            free(cPattern)
        }

        let flags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
        if glob(cPattern, flags, nil, &gt) == 0 {
            #if os(Linux)
                let matchc = gt.gl_pathc
            #else
                let matchc = gt.gl_matchc
            #endif

            return (0..<Int(matchc)).flatMap { index in
                if let path = String(validatingUTF8: gt.gl_pathv[index]) {
                    return Path(path)
                }

                return nil
            }
        }

        // GLOB_NOMATCH
        return []
    }

    public func glob(pattern: String) -> [Path] {
        return Path.glob((self + pattern).description)
    }

}
