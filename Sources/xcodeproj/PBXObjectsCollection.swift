import Foundation

@available(*, deprecated, message: "Will be deleted")
public typealias PBXObjectsCollection<T: Equatable> = [PBXObjectReference: T]

// MARK: - Dictionary extension when the key is PBXObjectReference

extension Dictionary where Key == PBXObjectReference {
    @available(*, deprecated, message: "Will be deleted")
    var references: [String] {
        return Array(keys.map({ $0.value }))
    }

    @available(*, deprecated, message: "Will be deleted")
    func contains(reference: String) -> Bool {
        return self[PBXObjectReference(reference)] != nil
    }

    @available(*, deprecated, message: "Will be deleted")
    func getReference(_ reference: String) -> Value? {
        return self[PBXObjectReference(reference)]
    }
}
