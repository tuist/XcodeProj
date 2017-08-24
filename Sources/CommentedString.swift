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

    private static let invalidCharacters = CharacterSet.alphanumerics.inverted
        .subtracting(CharacterSet(charactersIn: "_./"))

    var validString: String {
        switch string {
            case "": return "".quoted
            case "false": return "NO"
            case "true": return "YES"
            default: break
        }

        var escaped = string
        // escape newlines
        escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")

        // escape quotes
        var range: Range<String.Index>?
        if escaped.isQuoted {
            range = escaped.index(after: escaped.startIndex)..<escaped.index(before: escaped.endIndex)
        }
        escaped = escaped.replacingOccurrences(of: "([^\\\\])(\")", with: "$1\\\\$2", options: .regularExpression, range: range)

        if !escaped.isQuoted && escaped.rangeOfCharacter(from: CommentedString.invalidCharacters) != nil {
            escaped = escaped.quoted
        }

        return escaped
    }
    
}

// MARK: - CommentedString Extension (Hashable)

extension CommentedString: Hashable {
    
    var hashValue: Int { return string.hashValue }
    static func == (lhs: CommentedString, rhs: CommentedString) -> Bool {
        return lhs.string == rhs.string && lhs.comment == rhs.comment
    }
    
}

// MARK: - CommentedString Extension (ExpressibleByStringLiteral)

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
