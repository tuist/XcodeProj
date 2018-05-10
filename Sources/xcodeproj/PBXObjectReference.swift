import Foundation

/// Object used as a reference to PBXObjects from PBXProj.Objects.
public class PBXObjectReference: Hashable, CustomStringConvertible, ExpressibleByStringLiteral, Comparable {
    /// Boolean that indicates whether the id is temporary and needs
    /// to be regenerated when saving it to disk.
    private(set) var temporary: Bool

    /// String reference.
    private(set) var value: String
    
    /// Weak reference to the objects instance that contains the project objects.
    weak internal(set) var objects: PBXProj.Objects?

    /// Initializes a non-temporary reference.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String) {
        value = reference
        temporary = false
    }

    /// Initializes a temporary reference
    init() {
        value = String.random()
        temporary = true
    }

    /// Hash value.
    public var hashValue: Int {
        return value.hashValue
    }

    /// Compares two instances of PBXObjectReference
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: true if the two instances are equal.
    public static func == (lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
        return lhs.value == rhs.value &&
            lhs.temporary == rhs.temporary
    }

    /// Compares two instances.
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: comparison result.
    public static func < (lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
        return lhs.value < rhs.value
    }

    // MARK: - CustomStringConvertible

    public var description: String { return value }

    // MARK: - ExpressibleByStringLiteral

    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType

    public required convenience init(extendedGraphemeClusterLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }

    public required convenience init(unicodeScalarLiteral path: StringLiteralType) {
        self.init(stringLiteral: path)
    }

    public required init(stringLiteral value: StringLiteralType) {
        self.value = value
        temporary = false
    }
}
