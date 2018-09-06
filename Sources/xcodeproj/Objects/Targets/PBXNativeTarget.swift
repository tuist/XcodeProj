import Foundation

/// This is the element for a build target that produces a binary content (application or library).
public final class PBXNativeTarget: PBXTarget {
    // Target product install path.
    public var productInstallPath: String?

    @available(*, deprecated, message: "Use the constructor that takes objects instead of references")
    public init(name: String,
                buildConfigurationListReference: PBXObjectReference? = nil,
                buildPhaseReferences: [PBXObjectReference] = [],
                buildRuleReferences: [PBXObjectReference] = [],
                dependencyReferences: [PBXObjectReference] = [],
                productInstallPath: String? = nil,
                productName: String? = nil,
                productReference: PBXObjectReference? = nil,
                productType: PBXProductType? = nil) {
        self.productInstallPath = productInstallPath
        super.init(name: name,
                   buildConfigurationListReference: buildConfigurationListReference,
                   buildPhaseReferences: buildPhaseReferences,
                   buildRuleReferences: buildRuleReferences,
                   dependencyReferences: dependencyReferences,
                   productName: productName,
                   productReference: productReference,
                   productType: productType)
    }

    /// Initializes the native target with its attributes.
    ///
    /// - Parameters:
    ///   - name: target name.
    ///   - buildConfigurationList: build configuratino list.
    ///   - buildPhases: build phases.
    ///   - buildRules: build rules.
    ///   - dependencies: dependencies.
    ///   - productInstallPath: product install path.
    ///   - productName: product name.
    ///   - product: product file reference.
    ///   - productType: product type.
    public convenience init(name: String,
                            buildConfigurationList: XCConfigurationList? = nil,
                            buildPhases: [PBXBuildPhase] = [],
                            buildRules: [PBXBuildRule] = [],
                            dependencies: [PBXTargetDependency] = [],
                            productInstallPath: String? = nil,
                            productName: String? = nil,
                            product: PBXFileReference? = nil,
                            productType: PBXProductType? = nil) {
        self.init(name: name,
                  buildConfigurationListReference: buildConfigurationList?.reference,
                  buildPhaseReferences: buildPhases.map({ $0.reference }),
                  buildRuleReferences: buildRules.map({ $0.reference }),
                  dependencyReferences: dependencies.map({ $0.reference }),
                  productInstallPath: productInstallPath,
                  productName: productName,
                  productReference: product?.reference,
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
        dependencyReferences.append(targetDependencyReference)
        return targetDependencyReference
    }
}
