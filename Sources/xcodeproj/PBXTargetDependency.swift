import Foundation

/// This is the element for referencing other targets through content proxies.
public final class PBXTargetDependency: PBXObject {

    // MARK: - Attributes

    /// Target name.
    public var name: String?

    /// Target reference.
    public var target: PBXObjectReference?

    /// Target proxy
    public var targetProxy: PBXObjectReference?

    // MARK: - Init

    /// Initializes the target dependency.
    ///
    /// - Parameters:
    ///   - name: element name.
    ///   - target: element target.
    ///   - targetProxy: element target proxy.
    public init(name: String? = nil,
                target: PBXObjectReference? = nil,
                targetProxy: PBXObjectReference? = nil) {
        self.name = name
        self.target = target
        self.targetProxy = targetProxy
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
            target = referenceRepository.getOrCreate(reference: targetReference, objects: objects)
        }
        if let targetProxyReference: String = try container.decodeIfPresent(.targetProxy) {
            targetProxy = referenceRepository.getOrCreate(reference: targetProxyReference, objects: objects)
        }
        try super.init(from: decoder)
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
        if let targetReference = target, let targetObject: PBXTarget = try target?.object() {
            dictionary["target"] = .string(CommentedString(targetReference.value, comment: targetObject.name))
        }
        if let targetProxyReference = targetProxy {
            dictionary["targetProxy"] = .string(CommentedString(targetProxyReference.value, comment: "PBXContainerItemProxy"))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXTargetDependency"),
                value: .dictionary(dictionary))
    }
}
