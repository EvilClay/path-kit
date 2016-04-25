import POSIX

internal func getenv(named name: String) -> String? {
    let value = POSIX.getenv(name)

    guard value != nil else {
        return nil
    }

    return String(validatingUTF8: value)
}
