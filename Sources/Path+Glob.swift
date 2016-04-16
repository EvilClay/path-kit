import OperatingSystem

extension Path {
    public static func glob(pattern: String) -> [Path] {
		var gt = glob_t()
		defer { globfree(&gt) }

		let cPattern = strdup(pattern)
        defer { free(cPattern) }

        let flags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
        if OperatingSystem.glob(cPattern, flags, nil, &gt) == 0 {
			let count: Int

			#if os(Linux)
				count = Int(gt.gl_pathc)
			#else
				count = Int(gt.gl_matchc)
			#endif

            return (0..<count).flatMap { index in
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
        return Path.glob((self + pattern).path)
    }

}
