public enum ProjectAttribute: Sendable, Equatable {
    case string(String)
    case array([String])
    case attributeDictionary([String: [String: ProjectAttribute]])

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

extension ProjectAttribute: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else {
            let targetAttributes = try container.decode([String: [String: ProjectAttribute]].self)
            self = .attributeDictionary(targetAttributes)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(string):
            try container.encode(string)
        case let .array(array):
            try container.encode(array)
        case let .attributeDictionary(attributes):
            try container.encode(attributes)
        }
    }
}

extension ProjectAttribute: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self = .array(elements)
    }
}

extension ProjectAttribute: ExpressibleByStringInterpolation {
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}
