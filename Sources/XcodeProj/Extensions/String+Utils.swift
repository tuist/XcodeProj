import Foundation

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
            let randomValue = Int.random(in: 0..<base.count)
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
