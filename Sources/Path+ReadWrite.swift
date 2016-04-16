import OperatingSystem
import String
import C7

extension Path {
    /// Reads the file.
    ///
    /// - Returns: the contents of the file at the specified path.
    ///
    public func read() throws -> Data {
        let fd = open(path, O_RDONLY)

        if fd < 0 {
            throw Error.CouldNotOpenFile
        }
        defer {
            close(fd)
        }

        var info = stat()
        let ret = withUnsafeMutablePointer(&info) { infoPointer -> Bool in
            if fstat(fd, infoPointer) < 0 {
                return false
            }
            return true
        }

        if !ret {
            throw Error.Unreadable
        }

        let length = Int(info.st_size)

        let rawData = malloc(length)
        var remaining = Int(info.st_size)
        var total = 0
        while remaining > 0 {
            let advanced = rawData.advanced(by: total)

            let amt = read(fd, advanced, remaining)
            if amt < 0 {
                break
            }
            remaining -= amt
            total += amt
        }

        if remaining != 0 {
            throw Error.Unreadable
        }

        //thanks @Danappelxx
        let data = UnsafeMutablePointer<UInt8>(rawData)
        let buffer = UnsafeMutableBufferPointer<UInt8>(start: data, count: length)
        return Data(buffer)
    }

    /// Reads the file contents and encoded its bytes to string applying the given encoding.
    ///
    /// - Parameter encoding: the encoding which should be used to decode the data.
    ///   (by default: `NSUTF8StringEncoding`)
    ///
    /// - Returns: the contents of the file at the specified path as string.
    ///
    public func read(encoding: NSStringEncoding = NSUTF8StringEncoding) throws -> String {
        #if os(Linux)
            return try NSString(contentsOfFile: path, encoding: encoding).substringFromIndex(0) as String
        #else
            return try NSString(contentsOfFile: path, encoding: encoding).substring(from:0) as String
        #endif
    }

    /// Write a file.
    ///
    /// - Note: Works atomically: the data is written to a backup file, and then — assuming no
    ///   errors occur — the backup file is renamed to the name specified by path.
    ///
    /// - Parameter data: the contents to write to file.
    ///
    public func write(data: Data) throws {
        #if os(Linux)
            try data.writeToFile(normalize().path, options: .DataWritingAtomic)
        #else
            try data.write(toFile:normalize().path, options: .dataWritingAtomic)
        #endif
    }

    /// Reads the file.
    ///
    /// - Note: Works atomically: the data is written to a backup file, and then — assuming no
    ///   errors occur — the backup file is renamed to the name specified by path.
    ///
    /// - Parameter string: the string to write to file.
    ///
    /// - Parameter encoding: the encoding which should be used to represent the string as bytes.
    ///   (by default: `NSUTF8StringEncoding`)
    ///
    /// - Returns: the contents of the file at the specified path as string.
    ///
    public func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        #if os(Linux)
            try NSString(string: string).writeToFile(normalize().path, atomically: true, encoding: encoding)
        #else
            try NSString(string: string).write(toFile:normalize().path, atomically: true, encoding: encoding)
        #endif
    }

}
