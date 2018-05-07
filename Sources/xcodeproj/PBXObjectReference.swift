import Foundation

/// Object used as a reference to PBXObjects from PBXProj.Objects.
public class PBXObjectReference: Hashable, CustomStringConvertible, ExpressibleByStringLiteral {
    
    /// Boolean that indicates whether the id is temporary and needs
    /// to be regenerated when saving it to disk.
    private(set) var temporary: Bool
    
    /// String reference.
    private(set) var reference: String
    
    /// Initializes a non-temporary reference.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String) {
        self.reference = reference
        self.temporary = false
    }
    
    /// Initializes a temporary reference
    init() {
        self.reference = String.random()
        self.temporary = true
    }
    
    /// Hash value.
    public var hashValue: Int {
        return reference.hashValue
    }
    
    /// Compares two instances of PBXObjectReference
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: true if the two instances are equal.
    public static func ==(lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.temporary == rhs.temporary
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String { return self.reference }
    
    // MARK: - ExpressibleByStringLiteral
    
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    public convenience required init(extendedGraphemeClusterLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }
    
    public convenience required init(unicodeScalarLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }
    
    public required  init(stringLiteral value: StringLiteralType) {
        self.reference = value
        self.temporary = false
    }
}
