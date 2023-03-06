import Foundation

extension String {
    public var quoted: String {
        "\"\(self)\""
    }

    public var isQuoted: Bool {
        hasPrefix("\"") && hasSuffix("\"")
    }

    public static func random(length: Int = 20) -> String {
        let base: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0 ..< length {
            let randomValue: UInt32 = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
