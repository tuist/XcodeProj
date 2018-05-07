import Foundation

// Typealias that represents dictionary from string -> T where T is Referenceable (i.e. PBXObjects)

public typealias ReferenceableCollection<T: Equatable> = [PBXObjectReference: T]

extension Dictionary where Key == PBXObjectReference {

    public var references: [PBXObjectReference] {
        return Array(self.keys)
    }

    public var referenceValues: [Value] {
        return self.values.map { $0 }
    }

    public func contains(reference: Key) -> Bool {
        return self[reference] != nil
    }

    public func getReference(_ reference: Key) -> Value? {
        return self[reference]
    }

    mutating public func append(_ value: Value, reference: PBXObjectReference) {
        self[reference] = value
    }
}
