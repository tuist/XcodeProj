import Foundation

#if os(Linux)
    import SwiftGlibc

    public func arc4random_uniform(_ max: UInt32) -> Int32 {
        SwiftGlibc.rand() % Int32(max - 1)
    }
#endif

public extension String {
    var quoted: String {
        "\"\(self)\""
    }

    var isQuoted: Bool {
        hasPrefix("\"") && hasSuffix("\"")
    }

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0 ..< length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
