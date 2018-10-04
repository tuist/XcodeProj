import Foundation

/// Project object reference repository.
class PBXObjectReferenceRepository {
    /// References.
    var references: [String: PBXObjectReference] = [:]

    /// Returns and creates if it doesn't exist an object reference.
    ///
    /// - Parameters:
    ///   - reference: reference value.
    ///   - objects: objects.
    /// - Returns: object reference.
    func getOrCreate(reference: String, objects: PBXObjects) -> PBXObjectReference {
        if let objectReference = references[reference] {
            return objectReference
        }
        let objectReference = PBXObjectReference(reference, objects: objects)
        references[reference] = objectReference
        return objectReference
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
    static var context: CodingUserInfoKey = CodingUserInfoKey(rawValue: "context")!
}

/// Xcodeproj JSON decoder.
class XcodeprojJSONDecoder: JSONDecoder {
    /// Default init.
    init(context: ProjectDecodingContext = ProjectDecodingContext()) {
        super.init()
        userInfo = [.context: context]
    }
}

/// Xcodeproj property list decoder.
class XcodeprojPropertyListDecoder: PropertyListDecoder {
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
        return userInfo[.context] as! ProjectDecodingContext
    }
}
