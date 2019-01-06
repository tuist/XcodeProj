// sourcery:file: skipEquality
import Foundation

/// Class that represents a project element.
public class PBXObject: Hashable, Decodable, Equatable, AutoEquatable {
    /// Returns the unique identifier.
    /// Note: The unique identifier of an object might change when the project gets written.
    /// If you use this identifier from a scheme, make sure the project is written before the project is.
    public var uuid: String {
        return reference.value
    }

    /// The object reference in the project that contains it.
    let reference: PBXObjectReference

    /**
     Used to differentiate this object from other equatable ones for the purposes of uuid generation.

     This shouldn't be required to be set in normal circumstances.
     In some rare cases xcodeproj doesn't have enough context about otherwise equatable objects,
     so it has to resolve automatic uuid conflicts by appending numbers.
     This property can be used to provide more context to disambiguate these objects,
     which will result in more deterministic uuids.
     */
    public var context: String?

    // MARK: - Init

    init() {
        reference = PBXObjectReference()
        reference.setObject(self)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case reference
    }

    /// Initializes the object from its project representation.
    ///
    /// - Parameter decoder: XcodeprojPropertyListDecoder decoder.
    /// - Throws: an error if the object cannot be parsed.
    public required init(from decoder: Decoder) throws {
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let reference: String = try container.decode(.reference)
        self.reference = referenceRepository.getOrCreate(reference: reference, objects: objects)
        self.reference.setObject(self)
    }

    /// Object isa (type id)
    public static var isa: String {
        return String(describing: self)
    }

    public static func == (lhs: PBXObject,
                           rhs: PBXObject) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    @objc dynamic func isEqual(to _: Any?) -> Bool {
        return true
    }

    public var hashValue: Int {
        return reference.hashValue
    }

    // swiftlint:disable function_body_length
    public static func parse(reference: String, dictionary: [String: Any], userInfo: [CodingUserInfoKey: Any]) throws -> PBXObject {
        let decoder = XcodeprojJSONDecoder()
        decoder.userInfo = userInfo
        var mutableDictionary = dictionary
        mutableDictionary["reference"] = reference
        let data = try JSONSerialization.data(withJSONObject: mutableDictionary, options: [])
        guard let isa = dictionary["isa"] as? String else { throw PBXObjectError.missingIsa }
        switch isa {
        case PBXLegacyTarget.isa:
            return try decoder.decode(PBXLegacyTarget.self, from: data)
        case PBXNativeTarget.isa:
            return try decoder.decode(PBXNativeTarget.self, from: data)
        case PBXAggregateTarget.isa:
            return try decoder.decode(PBXAggregateTarget.self, from: data)
        case PBXBuildFile.isa:
            return try decoder.decode(PBXBuildFile.self, from: data)
        case PBXFileReference.isa:
            return try decoder.decode(PBXFileReference.self, from: data)
        case PBXProject.isa:
            return try decoder.decode(PBXProject.self, from: data)
        case PBXFileElement.isa:
            return try decoder.decode(PBXFileElement.self, from: data)
        case PBXGroup.isa:
            return try decoder.decode(PBXGroup.self, from: data)
        case PBXHeadersBuildPhase.isa:
            return try decoder.decode(PBXHeadersBuildPhase.self, from: data)
        case PBXFrameworksBuildPhase.isa:
            return try decoder.decode(PBXFrameworksBuildPhase.self, from: data)
        case XCConfigurationList.isa:
            return try decoder.decode(XCConfigurationList.self, from: data)
        case PBXResourcesBuildPhase.isa:
            return try decoder.decode(PBXResourcesBuildPhase.self, from: data)
        case PBXShellScriptBuildPhase.isa:
            return try decoder.decode(PBXShellScriptBuildPhase.self, from: data)
        case PBXSourcesBuildPhase.isa:
            return try decoder.decode(PBXSourcesBuildPhase.self, from: data)
        case PBXTargetDependency.isa:
            return try decoder.decode(PBXTargetDependency.self, from: data)
        case PBXVariantGroup.isa:
            return try decoder.decode(PBXVariantGroup.self, from: data)
        case XCBuildConfiguration.isa:
            return try decoder.decode(XCBuildConfiguration.self, from: data)
        case PBXCopyFilesBuildPhase.isa:
            return try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
        case PBXContainerItemProxy.isa:
            return try decoder.decode(PBXContainerItemProxy.self, from: data)
        case PBXReferenceProxy.isa:
            return try decoder.decode(PBXReferenceProxy.self, from: data)
        case XCVersionGroup.isa:
            return try decoder.decode(XCVersionGroup.self, from: data)
        case PBXRezBuildPhase.isa:
            return try decoder.decode(PBXRezBuildPhase.self, from: data)
        case PBXBuildRule.isa:
            return try decoder.decode(PBXBuildRule.self, from: data)
        default:
            throw PBXObjectError.unknownElement(isa)
        }
    }

    // swiftlint:enable function_body_length

    /// Returns the objects the object belong to.
    ///
    /// - Returns: objects the object belongs to.
    /// - Throws: an error if this method is accessed before the object has been added to a project.
    func objects() throws -> PBXObjects {
        guard let objects = self.reference.objects else {
            let objectType = String(describing: type(of: self))
            throw PBXObjectError.orphaned(type: objectType, reference: reference.value)
        }
        return objects
    }
}
