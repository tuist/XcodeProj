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
