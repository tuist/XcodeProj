import Foundation

@available(*, deprecated)
public class PBXReferencedObject<T: PBXObject>: Equatable {
    /// Reference.
    public let reference: String

    /// Object.
    public let object: T

    /// Initializes ReferencedObject with the reference and the object it referes to.
    ///
    /// - Parameters:
    ///   - reference: object reference.
    ///   - object: object.
    public init(reference: String, object: T) {
        self.reference = reference
        self.object = object
    }

    /// Returns true if the two instances are the same.
    ///
    /// - Parameters:
    ///   - lhs: first instance to be compared.
    ///   - rhs: second instance to be compared.
    /// - Returns: true if the two instances are the same.
    public static func == (lhs: PBXReferencedObject,
                           rhs: PBXReferencedObject) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.object == rhs.object
    }
}

// MARK: - Dictionary Extension (PBXObjectReference)

extension Dictionary where Key == PBXObjectReference, Value: PBXObject {
    /// Returns an array of referenced objects.
    public var referencedObjects: [PBXReferencedObject<Value>] {
        return map({ PBXReferencedObject(reference: $0.key.value, object: $0.value) })
    }
}
