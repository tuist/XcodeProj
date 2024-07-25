import Foundation

/// Object used as a reference to PBXObjects from PBXObjects.
class PBXObjectReference: NSObject, Comparable, NSCopying, @unchecked Sendable {
    private let lock = NSRecursiveLock()
    
    /// Boolean that indicates whether the id is temporary and needs
    /// to be regenerated when saving it to disk.
    var temporary: Bool {
        lock.withLock { _temporary }
    }
    private var _temporary: Bool

    /// String reference.
    var value: String {
        lock.withLock { _value }
    }
    private var _value: String
    

    /// Weak reference to the objects instance that contains the project objects.
    var objects: PBXObjects? {
        get {
            lock.withLock { _objects }
        }
        set {
            lock.withLock {
                _objects = newValue
            }
        }
    }
    private weak var _objects: PBXObjects?

    // QUESTION: this is exposed to the project but so is `getThrowingObject` and `getObject`.  What access patterns do we want to support?
    /// A weak reference to the object
    var object: PBXObject? {
        get {
            lock.withLock { _object }
        }
    }
    private weak var _object: PBXObject?

    /// Initializes a non-temporary reference.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String, objects: PBXObjects) {
        _value = reference
        _temporary = false
        _objects = objects
    }

    /// Initializes a temporary reference
    init(objects: PBXObjects? = nil) {
        _value = "TEMP_\(UUID().uuidString)"
        _temporary = true
        _objects = objects
    }

    /// Initializes the reference without objects.
    ///
    /// - Parameter reference: reference.
    init(_ reference: String) {
        _value = reference
        _temporary = false
    }

    /// Initializes the object reference with another object reference, copying its values.
    ///
    /// - Parameter objectReference: object reference to be initialized from.
    required init(_ objectReference: PBXObjectReference) {
        _value = objectReference.value
        _temporary = objectReference.temporary
    }

    /// Fixes its value making it permanent.
    ///
    /// - Parameter value: value.
    func fix(_ value: String) {
        lock.withLock {
            let object = objects?.delete(reference: self)
            _value = value
            _temporary = false
            if let object = object {
                objects?.add(object: object)
            }
        }
    }

    /// Invalidates the reference making it temporary.
    func invalidate() {
        lock.withLock {
            let object = _objects?.delete(reference: self)
            _value = "TEMP_\(UUID().uuidString)"
            _temporary = true
            if let object = object {
                _objects?.add(object: object)
            }
        }
        
    }

    /// Hash value.
    override var hash: Int {
        value.hashValue
    }

    func copy(with _: NSZone? = nil) -> Any {
        type(of: self).init(self)
    }

    /// Compares two instances of PBXObjectReference
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: true if the two instances are equal.
    static func == (lhs: PBXObjectReference, rhs: PBXObjectReference) -> Bool {
        lhs.isEqual(rhs)
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
        lhs.value < rhs.value
    }

    /// Sets the object so it can be retrieved quickly again later
    ///
    /// - Parameter object: The object
    func setObject(_ object: PBXObject) {
        lock.withLock {
            _object = object
        }
    }

    /// Returns the object the reference is referfing to.
    ///
    /// - Returns: object the reference is referring to. Returns nil if the objects property has been released or the reference doesn't exist
    func getObject<T: PBXObject>() -> T? {
        try? getThrowingObject()
    }

    /// Returns the object the reference is referfing to.
    ///
    /// - Returns: object the reference is referring to.
    /// - Throws: an errof it the objects property has been released or the reference doesn't exist.
    func getThrowingObject<T: PBXObject>() throws -> T {
        if let object = object as? T {
            return object
        }
        return try lock.withLock {
            guard let objects = objects else {
                throw PBXObjectError.objectsReleased
            }
            guard let object = objects.get(reference: self) as? T else {
                throw PBXObjectError.objectNotFound(value)
            }
            _object = object
            return object
        }
  
    }
}

extension Array where Element: PBXObject {
    func references() -> [PBXObjectReference] {
        map { $0.reference }
    }
}

extension Array where Element: PBXObjectReference {
    func objects<T: PBXObject>() -> [T] {
        compactMap { $0.getObject() }
    }
}
