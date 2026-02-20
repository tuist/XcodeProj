import Foundation

private extension UInt8 {
    static let tab: UInt8 = 9 // '\t'
    static let newline: UInt8 = 10 // '\n'
    static let backslash: UInt8 = 92 // '\'
    static let underscore: UInt8 = 95 // '_'
    static let doubleQuotes: UInt8 = 34 // '"'
    static let dollar: UInt8 = 36 // '$'
    static let slash: UInt8 = 47 // '/'

    static let dot: UInt8 = 46 // '.'
    static let nine: UInt8 = 57 // '9'

    static let capitalA: UInt8 = 65 // 'A'
    static let capitalZ: UInt8 = 90 // 'Z'

    static let smallA: UInt8 = 97 // 'a'
    static let smallN: UInt8 = 110 // 'n'
    static let smallT: UInt8 = 116 // 't'
    static let smallZ: UInt8 = 122 // 'z'
}

private extension ContiguousArray<CChar> {
    static let slashesUTF8CString = "//".utf8CString
    static let threeUnderscoresUTF8CString = "___".utf8CString
}

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

    /// Returns a valid string for Xcode projects.
    var validString: String {
        switch string {
        case "": return "\"\""
        case "false": return "NO"
        case "true": return "YES"
        default: break
        }

        var str = string
        return str.withUTF8 { buf -> String in
            let containsInvalidCharacters = buf.containsInvalidCharacters

            if !containsInvalidCharacters {
                let containsSpecialCheckCharacters = buf.containsSpecialCheckCharacters

                if !containsSpecialCheckCharacters {
                    return string
                } else if !buf.containsCString(ContiguousArray.slashesUTF8CString),
                          !buf.containsCString(ContiguousArray.threeUnderscoresUTF8CString) {
                    return string
                }
            }

            // calculate exact size
            let escapedCapacity = buf.escapedCommentCapacity

            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
                // write directly into String storage
                return String(unsafeUninitializedCapacity: escapedCapacity) { dst in
                    dst.fillValidString(from: buf)

                    return escapedCapacity
                }
            } else {
                let validStringBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: escapedCapacity)
                validStringBuffer.fillValidString(from: buf)

                return String(decoding: validStringBuffer, as: UTF8.self)
            }
        }
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

// MARK: - Private

private extension UnsafeMutableBufferPointer<UInt8> {
    /// Fills preallocated `UnsafeBufferPointer<UInt8>`
    func fillValidString(from buf: UnsafeBufferPointer<UInt8>) {
        var outIndex = 0
        
        self[outIndex] = .doubleQuotes
        outIndex += 1
        
        for ch in buf {
            switch ch {
            case .backslash:
                self[outIndex] = .backslash
                self[outIndex + 1] = .backslash
                outIndex += 2
                
            case .doubleQuotes:
                self[outIndex] = .backslash
                self[outIndex + 1] = .doubleQuotes
                outIndex += 2
                
            case .tab:
                self[outIndex] = .backslash
                self[outIndex + 1] = .smallT
                outIndex += 2
                
            case .newline:
                self[outIndex] = .backslash
                self[outIndex + 1] = .smallN
                outIndex += 2
                
            default:
                self[outIndex] = ch
                outIndex += 1
            }
        }
        
        self[outIndex] = .doubleQuotes
    }
}

private extension UnsafeBufferPointer<UInt8> {
    /// Valid characters are:
    /// 1. `_` and `$`
    /// 2. `.`...`9`
    /// 3. `A`...`Z`
    /// 4. `a`...`z`
    var containsInvalidCharacters: Bool {
        for ch in self {
            // ch == '_' || ch == '$'
            if ch == .underscore || ch == .dollar {
                continue
            }
            // ch >= '.' && ch <= '9'
            if ch >= .dot && ch <= .nine {
                continue
            }
            // ch >= 'A' && ch <= 'Z'
            if ch >= .capitalA && ch <= .capitalZ {
                continue
            }
            // ch >= 'a' && ch <= 'z'
            if ch >= .smallA && ch <= .smallZ {
                continue
            }

            return true
        }

        return false
    }

    /// Special check characters are `_` and `/`
    var containsSpecialCheckCharacters: Bool {
        for ch in self {
            if ch == .underscore || ch == .slash {
                return true
            }
        }

        return false
    }

    /// Calculates escaped string size
    /// Basically, `count + count(where: { [.backslash, .doubleQuotes, .tab, .newline].contains($0) }`
    var escapedCommentCapacity: Int {
        var escapeCount = 0

        for ch in self {
            switch ch {
            case .backslash, .doubleQuotes, .tab, .newline:
                escapeCount += 1   // each adds one extra byte
            default:
                break
            }
        }

        return count        // original bytes
             + escapeCount  // extra escape bytes
             + 2            // surrounding quotes
    }
}
