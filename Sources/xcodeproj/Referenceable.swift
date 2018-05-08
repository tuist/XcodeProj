import Foundation

// Typealias that represents dictionary from PBXObjectReference -> T where T is Referenceable (i.e. PBXObjects)

public typealias ReferenceableCollection<T: Equatable> = [PBXObjectReference: T]

extension Dictionary where Key == PBXObjectReference {
    public var references: [String] {
        return Array(keys.map({ $0.reference }))
    }

    public var referenceValues: [Value] {
        return values.map { $0 }
    }

    public func contains(reference: Key) -> Bool {
        return self[reference] != nil
    }

    public func contains(reference: String) -> Bool {
        return self[PBXObjectReference(reference)] != nil
    }

    public func getReference(_ reference: String) -> Value? {
        return self[PBXObjectReference(reference)]
    }

    public mutating func append(_ value: Value, reference: String) -> PBXObjectReference {
        let objectReference = PBXObjectReference(reference)
        self[objectReference] = value
        return objectReference
    }
}
