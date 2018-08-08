import Foundation

/// This is the element for a build target that produces a binary content (application or library).
public final class PBXNativeTarget: PBXTarget {
    // Target product install path.
    public var productInstallPath: String?

    public init(name: String,
                buildConfigurationListReference: PBXObjectReference? = nil,
                buildPhasesReferences: [PBXObjectReference] = [],
                buildRulesReferences: [PBXObjectReference] = [],
                dependenciesReferences: [PBXObjectReference] = [],
                productInstallPath: String? = nil,
                productName: String? = nil,
                productReference: PBXObjectReference? = nil,
                productType: PBXProductType? = nil) {
        self.productInstallPath = productInstallPath
        super.init(name: name,
                   buildConfigurationListReference: buildConfigurationListReference,
                   buildPhasesReferences: buildPhasesReferences,
                   buildRulesReferences: buildRulesReferences,
                   dependenciesReferences: dependenciesReferences,
                   productName: productName,
                   productReference: productReference,
                   productType: productType)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case productInstallPath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productInstallPath = try container.decodeIfPresent(.productInstallPath)
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        let (key, value) = try super.plistValues(proj: proj, isa: isa, reference: reference)
        guard case var PlistValue.dictionary(dict) = value else {
            throw XcodeprojWritingError.invalidType(class: String(describing: type(of: self)), expected: "Dictionary")
        }
        if let productInstallPath = productInstallPath {
            dict["productInstallPath"] = .string(CommentedString(productInstallPath))
        }
        return (key: key, value: .dictionary(dict))
    }
}

// MARK: - PBXNativeTarget Extension (PlistSerializable)

extension PBXNativeTarget: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        return try plistValues(proj: proj, isa: PBXNativeTarget.isa, reference: reference)
    }
}

// MARK: - Public

public extension PBXNativeTarget {
    /// Adds a dependency to the target.
    ///
    /// - Parameter target: dependency target.
    /// - Returns: target dependency reference.
    /// - Throws: an error if the dependency cannot be created.
    public func addDependency(target: PBXNativeTarget) throws -> PBXObjectReference? {
        let objects = try target.objects()
        guard let project = objects.projects.first?.value else {
            return nil
        }
        let proxy = PBXContainerItemProxy(containerPortalReference: project.reference,
                                          remoteGlobalIDReference: target.reference,
                                          proxyType: .nativeTarget,
                                          remoteInfo: target.name)
        let proxyReference = objects.addObject(proxy)
        let targetDependency = PBXTargetDependency(name: target.name,
                                                   targetReference: target.reference,
                                                   targetProxyReference: proxyReference)
        let targetDependencyReference = objects.addObject(targetDependency)
        dependenciesReferences.append(targetDependencyReference)
        return targetDependencyReference
    }
}
