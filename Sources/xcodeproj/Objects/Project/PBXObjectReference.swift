import Foundation

/// Object used as a reference to PBXObjects from PBXObjects.
class PBXObjectReference: NSObject, Comparable, NSCopying {
    /// Boolean that indicates whether the id is temporary and needs
    /// to be regenerated when saving it to disk.
    private(set) var temporary: Bool

    /// String reference.
    private(set) var value: String

    /// Weak reference to the objects instance that contains the project objects.
    weak var objects: PBXObjects?

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
        value = String.random()
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

    /// Initializes the object reference with another object reference, copying its values.
    ///
    /// - Parameter objectReference: object reference to be initialized from.
    required init(_ objectReference: PBXObjectReference) {
        value = objectReference.value
        temporary = objectReference.temporary
    }

    /// Fixes its value making it permanent.
    /// Since this object is used as a key in to refer objects from the PBXObjects instance, we need to delete
    /// the object and add it again to index the new reference. Otherwise we cannot access the element using
    /// the reference with the updated value.
    ///
    /// - Parameter value: value.
    func fix(_ value: String) {
        let object = objects?.delete(reference: self)
        self.value = value
        temporary = false
        if let object = object {
            objects?.add(object: object)
        }
    }

    /// Invalidates the reference making it temporary.
    func invalidate() {
        temporary = true
    }

    /// Hash value.
    override var hash: Int {
        return value.hashValue
    }

    func copy(with _: NSZone? = nil) -> Any {
        return type(of: self).init(self)
    }

    /// Compares two instances of PBXObjectReference
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: true if the two instances are equal.
    static func == (lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
        return lhs.isEqual(rhs)
    }

    /// Compares with another instance of PBXObjectReference.
    ///
    /// - Parameters:
    ///   - object: instance to be compared with.
    /// - Returns: true if the two instances are equal.
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PBXObjectReference else { return false }
        return value == object.value
    }

    /// Compares two instances.
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: comparison result.
    static func < (lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
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
        guard let object = objects.get(reference: self) as? T else {
            throw PBXObjectError.objectNotFound(value)
        }
        return object
    }
}

extension Array where Element: PBXObject {

    func references() -> [PBXObjectReference] {
        return map { $0.reference }
    }
}

extension Array where Element: PBXObjectReference {

    func objects<T: PBXObject>() -> [T] {
        return compactMap { try? $0.object() }
    }
}
