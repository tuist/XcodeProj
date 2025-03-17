import Foundation

/// Build settings.
public typealias BuildSettings = [String: BuildSetting]

private let yes = "YES"
private let no = "NO"

public enum BuildSetting: Sendable, Equatable {
    case string(String)
    case array([String])

    public var stringValue: String? {
        if case let .string(value) = self {
            value
        } else {
            nil
        }
    }

    public var boolValue: Bool? {
        if case let .string(value) = self {
            switch value {
            case yes: true
            case no: false
            default: nil
            }
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

extension BuildSetting: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .string(string):
            string
        case let .array(array):
            array.joined(separator: " ")
        }
    }
}

extension BuildSetting: Decodable {
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

extension BuildSetting: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .string(value ? yes : no)
    }
}
