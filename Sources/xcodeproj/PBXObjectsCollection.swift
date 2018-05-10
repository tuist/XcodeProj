import Foundation

@available(*, deprecated, message: "Will be deleted")
public typealias PBXObjectsCollection<T: Equatable> = [PBXObjectReference: T]

// MARK: - Dictionary extension when the key is PBXObjectReference

extension Dictionary where Key == PBXObjectReference {
    func getReference(_ reference: String) -> Value? {
        return self[PBXObjectReference(reference)]
    }
}
