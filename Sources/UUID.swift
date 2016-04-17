import OperatingSystem

final internal class UUID {

    // NOTE: uuid_t doesn’t exist in glibc
    // This is prone to collisions and should be replaced
    static func make() -> String {
        // Format: XXXXXXXX-XXXX-4XXX-YXXX-XXXXXXXXXXXX
        var uuid = ""

        for x in 0..<31 {
            if x == 8 || x == 15 || x == 19 {
                uuid += "-"
            } else if x == 12 {
                uuid += "-4"
            }

            let r = Int((random() % 16) | 0)
            uuid += String(x == 15 ? r&0x3|0x8 : r, radix: 16)
        }

        return uuid.uppercased()
    }

}
