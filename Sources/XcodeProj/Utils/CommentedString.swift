import Foundation
import XcodeProjCExt

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

    /// Substrings that cause Xcode to quote the string content.
    private let invalidStrings = [
        "___",
        "//",
    ]

    /// Returns a valid string for Xcode projects.
    var validString: String {
        switch string {
        case "": return "".quoted
        case "false": return "NO"
        case "true": return "YES"
        default: break
        }

        return string.withCString { buffer in
            let esc = XCPEscapedString(buffer)!
            let newString = String(cString: esc)
            free(UnsafeMutableRawPointer(mutating: esc))
            return newString
        }
    }
}

// MARK: - Hashable

extension CommentedString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
    }

    static func == (lhs: CommentedString, rhs: CommentedString) -> Bool {
        return lhs.string == rhs.string && lhs.comment == rhs.comment
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
