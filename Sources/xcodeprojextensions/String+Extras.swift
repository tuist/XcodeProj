import Foundation

extension String {
    
    public var quoted: String {
        return "\"\(self)\""
    }

    public var isQuoted: Bool {
        return hasPrefix("\"") && hasSuffix("\"")
    }
    
}
