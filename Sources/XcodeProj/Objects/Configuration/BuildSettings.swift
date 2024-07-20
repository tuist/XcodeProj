import Foundation

/// Build settings.
public typealias BuildSettings = [String: BuildSetting]

public enum BuildSetting: Sendable, Equatable {
    case string(String)
    case array([String])
}

extension BuildSetting: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do  {
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
        case .string(let string):
            try container.encode(string)
        case .array(let array):
            try container.encode(array)
        }
    }
}

extension BuildSetting: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self = .array(elements)
    }
}

extension BuildSetting: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}
