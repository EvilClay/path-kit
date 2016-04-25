import POSIX
import String
import C7

extension Path {

    enum ReadWriteError: ErrorProtocol {
        case CouldNotOpenFile(String)
        case Unreadable(String)
    }

    /// Reads the file.
    ///
    /// - Returns: the contents of the file at the specified path.
    ///
    public func read() throws -> Data {
        let fd = open(path, O_RDONLY)

        if fd < 0 {
            throw ReadWriteError.CouldNotOpenFile(path)
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
            throw ReadWriteError.Unreadable(path)
        }

        let length = Int(info.st_size)

        let rawData = malloc(length)
        var remaining = Int(info.st_size)
        var total = 0
        while remaining > 0 {
            let advanced = rawData.advanced(by: total)

            let amt = POSIX.read(fd, advanced, remaining)
            if amt < 0 {
                break
            }
            remaining -= amt
            total += amt
        }

        if remaining != 0 {
            throw ReadWriteError.Unreadable(path)
        }

        //thanks @Danappelxx
        let data = UnsafeMutablePointer<UInt8>(rawData)
        let buffer = UnsafeMutableBufferPointer<UInt8>(start: data, count: length)
        return Data(buffer)
    }

    /// Reads the file contents and converts to string
    ///
    /// - Returns: the contents of the file at the specified path as string.
    ///
    public func readString() throws -> String? {
        let data = try self.read()
        return try String(data: data)
    }

    /// Write a file.
    ///
    /// - Parameter data: the contents to write to file.
    ///
    public func write(data: Data) throws {
        let file = fopen(path, "w")

        guard file != nil else {
            throw ReadWriteError.CouldNotOpenFile(path)
        }

        defer {
            fclose(file)
        }

        fwrite(data.bytes, sizeof(Byte), data.bytes.count, file)
    }

    /// Writes the file.
    ///
    /// - Parameter string: the string to write to file.
    ///
    public func write(string: String) throws {
        try write(data: Data(string))
    }

}
