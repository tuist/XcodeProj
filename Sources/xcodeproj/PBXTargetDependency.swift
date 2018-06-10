import Foundation

/// This is the element for referencing other targets through content proxies.
public final class PBXTargetDependency: PBXObject {

    // MARK: - Attributes

    /// Target name.
    public var name: String?

    /// Target reference.
    public var targetReference: PBXObjectReference?

    /// Target proxy
    public var targetProxyReference: PBXObjectReference?

    // MARK: - Init

    /// Initializes the target dependency.
    ///
    /// - Parameters:
    ///   - name: element name.
    ///   - target: element target.
    ///   - targetProxy: element target proxy.
    public init(name: String? = nil,
                targetReference: PBXObjectReference? = nil,
                targetProxyReference: PBXObjectReference? = nil) {
        self.name = name
        self.targetReference = targetReference
        self.targetProxyReference = targetProxyReference
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case name
        case target
        case targetProxy
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        name = try container.decodeIfPresent(.name)
        if let targetReference: String = try container.decodeIfPresent(.target) {
            self.targetReference = referenceRepository.getOrCreate(reference: targetReference, objects: objects)
        }
        if let targetProxyReference: String = try container.decodeIfPresent(.targetProxy) {
            self.targetProxyReference = referenceRepository.getOrCreate(reference: targetProxyReference, objects: objects)
        }
        try super.init(from: decoder)
    }
}

// MARK: - Public

public extension PBXTargetDependency {
    /// Materializes the target reference returning the target the object reference refers to.
    ///
    /// - Returns: target dependency target.
    /// - Throws: an error if the object doesn't exist in the project.
    public func target() throws -> PBXTarget? {
        return try targetReference?.object()
    }

    /// Materializes the target proxy reference returning the target the object reference refers to.
    ///
    /// - Returns: target dependency proxy target.
    /// - Throws: an error if the object doesn't exist in the project.
    public func targetProxy() throws -> PBXTarget? {
        return try targetProxyReference?.object()
    }
}

// MARK: - PlistSerializable

extension PBXTargetDependency: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXTargetDependency.isa))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let targetReference = targetReference, let targetObject: PBXTarget = try targetReference.object() {
            dictionary["target"] = .string(CommentedString(targetReference.value, comment: targetObject.name))
        }
        if let targetProxyReference = targetProxyReference {
            dictionary["targetProxy"] = .string(CommentedString(targetProxyReference.value, comment: "PBXContainerItemProxy"))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXTargetDependency"),
                value: .dictionary(dictionary))
    }
}
