import Foundation

/// It represents a plist value.
///
/// - string: commented string.
/// - array: array of plist values.
/// - dictionary: dictionary where the keys are a commented strings and the values are a plist values.
indirect enum PlistValue {
    case string(CommentedString)
    case array([PlistValue])
    case dictionary([CommentedString: PlistValue])

    var string: CommentedString? {
        switch self {
        case let .string(string): string
        default: nil
        }
    }

    var array: [PlistValue]? {
        switch self {
        case let .array(array): array
        default: nil
        }
    }

    var dictionary: [CommentedString: PlistValue]? {
        switch self {
        case let .dictionary(dictionary): dictionary
        default: nil
        }
    }
}

// MARK: - PlistValue Extension (ExpressibleByArrayLiteral)

extension PlistValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: PlistValue...) {
        self = .array(elements)
    }
}

// MARK: - PlistValue Extension (ExpressibleByDictionaryLiteral)

extension PlistValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (CommentedString, PlistValue)...) {
        var dictionary: [CommentedString: PlistValue] = [:]
        elements.forEach { dictionary[$0.0] = $0.1 }
        self = .dictionary(dictionary)
    }
}

// MARK: - PlistValue Extension (ExpressibleByStringLiteral)

extension PlistValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(CommentedString(value))
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(CommentedString(value))
    }

    public init(unicodeScalarLiteral value: String) {
        self = .string(CommentedString(value))
    }
}

// MARK: PlistValue Extension (Equatable)

extension PlistValue: Equatable {
    static func == (lhs: PlistValue, rhs: PlistValue) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhsString), .string(rhsString)):
            lhsString == rhsString
        case let (.array(lhsArray), .array(rhsArray)):
            lhsArray == rhsArray
        case let (.dictionary(lhsDictionary), .dictionary(rhsDictionary)):
            lhsDictionary == rhsDictionary
        default:
            false
        }
    }
}

// MARK: - Dictionary Extension (PlistValue)

extension [String: BuildSetting] {
    func plist() -> PlistValue {
        var dictionary: [CommentedString: PlistValue] = [:]
        forEach { key, value in
            switch value {
            case let .string(stringValue):
                dictionary[CommentedString(key)] = PlistValue.string(CommentedString(stringValue))
            case let .array(arrayValue):
                dictionary[CommentedString(key)] = arrayValue.plist()
            }
        }
        return .dictionary(dictionary)
    }
}

extension [String: BuildFileSetting] {
    func plist() -> PlistValue {
        var dictionary: [CommentedString: PlistValue] = [:]
        forEach { key, value in
            switch value {
            case let .string(stringValue):
                dictionary[CommentedString(key)] = PlistValue.string(CommentedString(stringValue))
            case let .array(arrayValue):
                dictionary[CommentedString(key)] = arrayValue.plist()
            }
        }
        return .dictionary(dictionary)
    }
}

extension [String: ProjectAttribute] {
    func plist() -> PlistValue {
        var dictionary: [CommentedString: PlistValue] = [:]
        forEach { key, value in
            switch value {
            case let .string(stringValue):
                dictionary[CommentedString(key)] = PlistValue.string(CommentedString(stringValue))
            case let .array(arrayValue):
                dictionary[CommentedString(key)] = arrayValue.plist()
            case let .attributeDictionary(attributes):
                dictionary[CommentedString(key)] = attributes.mapValues { $0.plist() }.plist()
            case let .targetReference(object):
                dictionary[CommentedString(key)] = .string(CommentedString(object.reference.value))
            }
        }
        return .dictionary(dictionary)
    }
}

extension Dictionary where Key == String {
    func plist() -> PlistValue {
        var dictionary: [CommentedString: PlistValue] = [:]
        forEach { key, value in
            if let array = value as? [Any] {
                dictionary[CommentedString(key)] = array.plist()
            } else if let subDictionary = value as? [String: Any] {
                dictionary[CommentedString(key)] = subDictionary.plist()
            } else if let string = value as? CustomStringConvertible {
                dictionary[CommentedString(key)] = .string(CommentedString(string.description))
            } else if let plistValue = value as? PlistValue {
                dictionary[CommentedString(key)] = plistValue
            }
        }
        return .dictionary(dictionary)
    }
}

// MARK: - Array Extension (PlistValue)

extension Array {
    func plist() -> PlistValue {
        .array(compactMap { element -> PlistValue? in
            if let array = element as? [Any] {
                return array.plist()
            } else if let dictionary = element as? [String: Any] {
                return dictionary.plist()
            } else if let string = element as? CustomStringConvertible {
                return PlistValue.string(CommentedString(string.description))
            }
            return nil
        })
    }
}
