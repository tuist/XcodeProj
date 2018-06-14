import Foundation

/// Object used as a reference to PBXObjects from PBXObjects.
public class PBXObjectReference: Hashable, Comparable {
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
    init(_ reference: String, objects: PBXObjects) {
        value = reference
        temporary = false
        self.objects = objects
    }

    /// Initializes a temporary reference
    init(objects: PBXObjects? = nil) {
        value = String.random().uppercased()
        temporary = true
        self.objects = objects
    }

    /// Initializes the reference without objects.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String) {
        value = reference
        temporary = false
    }

    /// Fixes the value of the reference with the given value.
    ///
    /// - Parameter value: reference string value.
    func fix(_ value: String) {
        self.value = value
        temporary = false
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
        return lhs.value == rhs.value
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

    /// Returns the object the reference is referfing to.
    ///
    /// - Returns: object the reference is referring to.
    /// - Throws: an errof it the objects property has been released or the reference doesn't exist.
    func object<T>() throws -> T {
        guard let objects = objects else {
            throw PBXObjectError.objectsReleased
        }
        guard let object = objects.getObject(self) as? T else {
            throw PBXObjectError.objectNotFound(value)
        }
        return object
    }
}
