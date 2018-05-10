import Foundation

/// Object used as a reference to PBXObjects from PBXObjects.
public class PBXObjectReference: Hashable, CustomStringConvertible, Comparable {
    /// Boolean that indicates whether the id is temporary and needs
    /// to be regenerated when saving it to disk.
    private(set) var temporary: Bool

    /// String reference.
    private(set) var value: String

    /// Weak reference to the objects instance that contains the project objects.
    internal(set) weak var objects: PBXObjects?

    /// Initializes a non-temporary reference.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String, objects: PBXObjects? = nil) {
        value = reference
        temporary = false
        self.objects = objects
    }

    /// Initializes a temporary reference
    init(objects: PBXObjects? = nil) {
        value = String.random()
        temporary = true
        self.objects = objects
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
}
