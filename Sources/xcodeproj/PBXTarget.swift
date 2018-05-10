import Foundation

/// This element is an abstract parent for specialized targets.
public class PBXTarget: PBXContainerItem {
    /// Target build configuration list.
    public var buildConfigurationList: String?

    /// Target build phases.
    public var buildPhases: [PBXObjectReference]

    /// Target build rules.
    public var buildRules: [String]

    /// Target dependencies.
    public var dependencies: [String]

    /// Target name.
    public var name: String

    /// Target product name.
    public var productName: String?

    /// Target product reference.
    public var productReference: String?

    /// Target product type.
    public var productType: PBXProductType?

    public init(name: String,
                buildConfigurationList: String? = nil,
                buildPhases: [PBXObjectReference] = [],
                buildRules: [String] = [],
                dependencies: [String] = [],
                productName: String? = nil,
                productReference: String? = nil,
                productType: PBXProductType? = nil) {
        self.buildConfigurationList = buildConfigurationList
        self.buildPhases = buildPhases
        self.buildRules = buildRules
        self.dependencies = dependencies
        self.name = name
        self.productName = productName
        self.productReference = productReference
        self.productType = productType
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildConfigurationList
        case buildPhases
        case buildRules
        case dependencies
        case name
        case productName
        case productReference
        case productType
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        name = try container.decode(.name)
        buildConfigurationList = try container.decodeIfPresent(.buildConfigurationList)
        let buildPhasesReferences: [String] = try container.decodeIfPresent(.buildPhases) ?? []
        buildPhases = buildPhasesReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        buildRules = try container.decodeIfPresent(.buildRules) ?? []
        dependencies = try container.decodeIfPresent(.dependencies) ?? []
        productName = try container.decodeIfPresent(.productName)
        productReference = try container.decodeIfPresent(.productReference)
        productType = try container.decodeIfPresent(.productType)
        try super.init(from: decoder)
    }

    func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(isa))
        let buildConfigurationListComment = "Build configuration list for \(isa) \"\(name)\""
        if let buildConfigurationList = buildConfigurationList {
            dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationList, comment: buildConfigurationListComment))
        }
        dictionary["buildPhases"] = try .array(buildPhases
            .map { (buildPhaseReference: PBXObjectReference) in
                let buildPhase: PBXBuildPhase = try buildPhaseReference.object()
                return .string(CommentedString(buildPhaseReference.value, comment: buildPhase.name()))
        })

        // Xcode doesn't write PBXAggregateTarget buildRules or empty PBXLegacyTarget buildRules
        if !(self is PBXAggregateTarget), !(self is PBXLegacyTarget) || !buildRules.isEmpty {
            dictionary["buildRules"] = .array(buildRules.map { .string(CommentedString($0, comment: PBXBuildRule.isa)) })
        }

        dictionary["dependencies"] = .array(dependencies.map { .string(CommentedString($0, comment: PBXTargetDependency.isa)) })
        dictionary["name"] = .string(CommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(CommentedString(productType.rawValue))
        }
        if let productReference = productReference {
            let productReferenceComment = proj.objects.fileName(fileReference: productReference)
            dictionary["productReference"] = .string(CommentedString(productReference, comment: productReferenceComment))
        }
        return (key: CommentedString(reference, comment: name),
                value: .dictionary(dictionary))
    }
}

// MARK: - PBXTarget (Convenient)

public extension PBXTarget {
    /// Returns the sources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func sourcesBuildPhase() throws -> PBXSourcesBuildPhase? {
        return try buildPhases
            .compactMap({ try $0.object() as PBXSourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }

    /// Returns the resources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func resourcesBuildPhase() throws -> PBXResourcesBuildPhase? {
        return try buildPhases
            .compactMap({ try $0.object() as PBXResourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }
}
