import Foundation

extension KeyedDecodingContainer {
    func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        try decode(T.self, forKey: key)
    }

    func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        try decodeIfPresent(T.self, forKey: key)
    }

    func decodeIntIfPresent(_ key: KeyedDecodingContainer.Key) throws -> UInt? {
        if let string: String = try? decodeIfPresent(key) {
            return UInt(string)
        } else if let bool: Bool = try? decodeIfPresent(key) {
            return bool ? 0 : 1
        } else if let int: UInt = try decodeIfPresent(key) {
            // don't `try?` here in case key _does_ exist but isn't an expected type
            // ie. not a string/bool/int
            return int
        } else {
            return nil
        }
    }

    func decodeIntBool(_ key: KeyedDecodingContainer.Key) throws -> Bool {
        guard let bool = try decodeIntBoolIfPresent(key) else {
            return false
        }
        return bool
    }

    func decodeIntBoolIfPresent(_ key: KeyedDecodingContainer.Key) throws -> Bool? {
        guard let int = try decodeIntIfPresent(key) else {
            return nil
        }

        guard int <= 2 else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected to decode Bool but found a number that is not 0 or 1")
        }

        return int == 1
    }
}
