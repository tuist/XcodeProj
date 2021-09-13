import Foundation

/// String that includes a comment
struct CommentedString {
    /// Entity string value.
    let string: String

    /// String comment.
    let comment: String?

    /// Initializes the commented string with the value and the comment.
    ///
    /// - Parameters:
    ///   - string: string value.
    ///   - comment: comment.
    init(_ string: String, comment: String? = nil) {
        self.string = string
        self.comment = comment
    }

    /// Set of characters that are invalid.
    private static var invalidCharacters: CharacterSet = {
        var invalidSet = CharacterSet(charactersIn: "_$")
        invalidSet.insert(charactersIn: UnicodeScalar(".") ... UnicodeScalar("9"))
        invalidSet.insert(charactersIn: UnicodeScalar("A") ... UnicodeScalar("Z"))
        invalidSet.insert(charactersIn: UnicodeScalar("a") ... UnicodeScalar("z"))
        invalidSet.invert()
        return invalidSet
    }()

    /// Set of characters that are invalid.
    private static var specialCheckCharacters = CharacterSet(charactersIn: "_/")

    /// Returns a valid string for Xcode projects.
    var validString: String {
        switch string {
        case "": return "\"\""
        case "false": return "NO"
        case "true": return "YES"
        default: break
        }

        if string.rangeOfCharacter(from: CommentedString.invalidCharacters) == nil {
            if string.rangeOfCharacter(from: CommentedString.specialCheckCharacters) == nil {
                return string
            } else if !string.contains("//") && !string.contains("___") {
                return string
            }
        }

        let escaped = string.reduce(into: "") { escaped, character in
            // As an optimization, only look at the first scalar. This means we're doing a numeric comparison instead
            // of comparing arbitrary-length characters. This is safe because all our cases are a single scalar.
            switch character.unicodeScalars.first {
            case "\\":
                escaped.append("\\\\")
            case "\"":
                escaped.append("\\\"")
            case "\t":
                escaped.append("\\t")
            case "\n":
                escaped.append("\\n")
            default:
                escaped.append(character)
            }
        }
        return "\"\(escaped)\""
    }
}

// MARK: - Hashable

extension CommentedString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
    }

    static func == (lhs: CommentedString, rhs: CommentedString) -> Bool {
        lhs.string == rhs.string && lhs.comment == rhs.comment
    }
}

// MARK: - ExpressibleByStringLiteral

extension CommentedString: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}
