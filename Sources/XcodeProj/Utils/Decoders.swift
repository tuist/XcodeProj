import Foundation

/// Project object reference repository.
class PBXObjectReferenceRepository {
    /// References.
    var references: [String: PBXObjectReference] = [:]
    let lock = NSRecursiveLock()

    /// Returns and creates if it doesn't exist an object reference.
    ///
    /// - Parameters:
    ///   - reference: reference value.
    ///   - objects: objects.
    /// - Returns: object reference.
    func getOrCreate(reference: String, objects: PBXObjects) -> PBXObjectReference {
        lock.whileLocked {
            if let objectReference = references[reference] {
                return objectReference
            }
            let objectReference = PBXObjectReference(reference, objects: objects)
            references[reference] = objectReference
            return objectReference
        }
    }
}

/// Context used when the project is being decoded.
class ProjectDecodingContext {
    /// Object reference repository.
    let objectReferenceRepository: PBXObjectReferenceRepository

    /// Objects.
    let objects: PBXObjects

    init() {
        objectReferenceRepository = PBXObjectReferenceRepository()
        objects = PBXObjects(objects: [])
    }
}

// MARK: - CodingUserInfoKey (Context)

extension CodingUserInfoKey {
    /// Context user info key.
    static let context: CodingUserInfoKey = .init(rawValue: "context")!
}

/// Xcodeproj JSON decoder.
final class XcodeprojJSONDecoder: JSONDecoder, @unchecked Sendable {
    /// Default init.
    init(context: ProjectDecodingContext = ProjectDecodingContext()) {
        super.init()
        userInfo = [.context: context]
    }
}

/// Xcodeproj property list decoder.
final class XcodeprojPropertyListDecoder: PropertyListDecoder, @unchecked Sendable {
    /// Default init.
    init(context: ProjectDecodingContext = ProjectDecodingContext()) {
        super.init()
        userInfo = [.context: context]
    }
}

// MARK: - Decoder (Context)

extension Decoder {
    /// Returns the decoding context.
    var context: ProjectDecodingContext {
        // swiftlint:disable:next force_cast
        userInfo[.context] as! ProjectDecodingContext
    }
}
