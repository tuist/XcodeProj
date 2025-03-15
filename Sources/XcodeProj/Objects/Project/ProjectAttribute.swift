public enum ProjectAttribute: Equatable {
    case string(String)
    case array([String])
    case targetReference(PBXObject)
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

extension ProjectAttribute: Decodable {
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

extension ProjectAttribute: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, [String: ProjectAttribute])...) {
        self = .attributeDictionary(Dictionary(uniqueKeysWithValues: elements))
    }
}
