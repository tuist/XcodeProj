import Foundation

/// This is the element for referencing other targets through content proxies.
public final class PBXTargetDependency: PBXObject {
    // MARK: - Attributes

    /// Target name.
    public var name: String?

    /// Target reference.
    @available(*, deprecated, message: "Use target instead")
    public var targetReference: PBXObjectReference?

    /// Target.
    public var target: PBXTarget? {
        return try! targetReference?.object()
    }

    /// Target proxy reference.
    @available(*, deprecated, message: "Use targetProxy instead")
    public var targetProxyReference: PBXObjectReference?

    /// Target proxy.
    public var targetProxy: PBXContainerItemProxy? {
        return try! targetProxyReference?.object()
    }

    // MARK: - Init

    /// Initializes the target dependency.
    ///
    /// - Parameters:
    ///   - name: element name.
    ///   - target: element target.
    ///   - targetProxy: element target proxy.
    @available(*, deprecated, message: "Use the constructor that takes objects instead of references")
    public init(name: String? = nil,
                targetReference: PBXObjectReference? = nil,
                targetProxyReference: PBXObjectReference? = nil) {
        self.name = name
        self.targetReference = targetReference
        self.targetProxyReference = targetProxyReference
        super.init()
    }

    /// Initializes the target dependency with dependencies as objects.
    ///
    /// - Parameters:
    ///   - name: Dependency name.
    ///   - target: Target.
    ///   - targetProxy: Target proxy.
    public convenience init(name: String? = nil,
                            target: PBXTarget? = nil,
                            targetProxy: PBXContainerItemProxy? = nil) {
        self.init(name: name,
                  targetReference: target?.reference,
                  targetProxyReference: targetProxy?.reference)
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

// MARK: - PlistSerializable

extension PBXTargetDependency: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXTargetDependency.isa))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let targetReference = targetReference {
            let targetObject: PBXTarget? = try? targetReference.object()
            dictionary["target"] = .string(CommentedString(targetReference.value, comment: targetObject?.name))
        }
        if let targetProxyReference = targetProxyReference {
            dictionary["targetProxy"] = .string(CommentedString(targetProxyReference.value, comment: "PBXContainerItemProxy"))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXTargetDependency"),
                value: .dictionary(dictionary))
    }
}
