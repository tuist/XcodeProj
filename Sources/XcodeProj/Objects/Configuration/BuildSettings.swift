import Foundation

/// Build settings.
public typealias BuildSettings = [String: BuildSetting]

public enum BuildSetting: Sendable, Equatable {
    case string(String)
    case array([String])

    var valueForWriting: String {
        switch self {
        case let .string(string):
            string
        case let .array(array):
            array.joined(separator: " ")
        }
    }

    public var stringValue: String? {
        if case let .string(value) = self {
            value
        } else {
            nil
        }
    }

    public var arrayValue: [String]? {
        if case let .array(value) = self {
            value
        } else {
            nil
        }
    }
}

extension BuildSetting: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let string = try container.decode(String.self)
            self = .string(string)
        } catch {
            let array = try container.decode([String].self)
            self = .array(array)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(string):
            try container.encode(string)
        case let .array(array):
            try container.encode(array)
        }
    }
}

extension BuildSetting: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self = .array(elements)
    }
}

extension BuildSetting: ExpressibleByStringInterpolation {
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}
