import Foundation

/// Represents a collection of PBXObjects.
public typealias PBXObjectsCollection<T: Equatable> = [PBXObjectReference: T]

// MARK: - Dictionary extension when the key is PBXObjectReference

extension Dictionary where Key == PBXObjectReference {
    // TODO: Remove
    var references: [String] {
        return Array(keys.map({ $0.value }))
    }

    // TODO: Remove
    func contains(reference: String) -> Bool {
        return self[PBXObjectReference(reference)] != nil
    }

    // TODO: Remove
    func getReference(_ reference: String) -> Value? {
        return self[PBXObjectReference(reference)]
    }
}
