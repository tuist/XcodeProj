import Foundation

/// This element is an abstract parent for specialized targets.
public class PBXTarget: PBXContainerItem {
    /// Target build configuration list.
    public var buildConfigurationListReference: PBXObjectReference?

    /// Target build phases.
    public var buildPhasesReferences: [PBXObjectReference]

    /// Target build rules.
    public var buildRulesReferences: [PBXObjectReference]

    /// Target dependencies.
    public var dependenciesReferences: [PBXObjectReference]

    /// Target name.
    public var name: String

    /// Target product name.
    public var productName: String?

    /// Target product reference.
    public var productReference: PBXObjectReference?

    /// Target product type.
    public var productType: PBXProductType?

    public init(name: String,
                buildConfigurationListReference: PBXObjectReference? = nil,
                buildPhasesReferences: [PBXObjectReference] = [],
                buildRulesReferences: [PBXObjectReference] = [],
                dependenciesReferences: [PBXObjectReference] = [],
                productName: String? = nil,
                productReference: PBXObjectReference? = nil,
                productType: PBXProductType? = nil) {
        self.buildConfigurationListReference = buildConfigurationListReference
        self.buildPhasesReferences = buildPhasesReferences
        self.buildRulesReferences = buildRulesReferences
        self.dependenciesReferences = dependenciesReferences
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
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(.name)
        if let buildConfigurationListReference: String = try container.decodeIfPresent(.buildConfigurationList) {
            self.buildConfigurationListReference = objectReferenceRepository.getOrCreate(reference: buildConfigurationListReference, objects: objects)
        } else {
            buildConfigurationListReference = nil
        }
        let buildPhasesReferences: [String] = try container.decodeIfPresent(.buildPhases) ?? []
        self.buildPhasesReferences = buildPhasesReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        let buildRulesReferences: [String] = try container.decodeIfPresent(.buildRules) ?? []
        self.buildRulesReferences = buildRulesReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        let dependenciesReferences: [String] = try container.decodeIfPresent(.dependencies) ?? []
        self.dependenciesReferences = dependenciesReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        productName = try container.decodeIfPresent(.productName)
        if let productReferenceString: String = try container.decodeIfPresent(.productReference) {
            productReference = objectReferenceRepository.getOrCreate(reference: productReferenceString, objects: objects)
        } else {
            productReference = nil
        }
        productType = try container.decodeIfPresent(.productType)
        try super.init(from: decoder)
    }

    func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(isa))
        let buildConfigurationListComment = "Build configuration list for \(isa) \"\(name)\""
        if let buildConfigurationListReference = buildConfigurationListReference {
            dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationListReference.value, comment: buildConfigurationListComment))
        }
        dictionary["buildPhases"] = try .array(buildPhasesReferences
            .map { (buildPhaseReference: PBXObjectReference) in
                let buildPhase: PBXBuildPhase = try buildPhaseReference.object()
                return .string(CommentedString(buildPhaseReference.value, comment: buildPhase.name()))
        })

        // Xcode doesn't write PBXAggregateTarget buildRules or empty PBXLegacyTarget buildRules
        if !(self is PBXAggregateTarget), !(self is PBXLegacyTarget) || !buildRulesReferences.isEmpty {
            dictionary["buildRules"] = .array(buildRulesReferences.map { .string(CommentedString($0.value, comment: PBXBuildRule.isa)) })
        }

        dictionary["dependencies"] = .array(dependenciesReferences.map { .string(CommentedString($0.value, comment: PBXTargetDependency.isa)) })
        dictionary["name"] = .string(CommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(CommentedString(productType.rawValue))
        }
        if let productReference = productReference {
            let fileElement: PBXFileElement = try productReference.object()
            dictionary["productReference"] = .string(CommentedString(productReference.value, comment: fileElement.fileName()))
        }
        return (key: CommentedString(reference, comment: name),
                value: .dictionary(dictionary))
    }
}

// MARK: - Public

public extension PBXTarget {
    /// Returns the build configuration list object.
    ///
    /// - Returns: builc configuration list object.
    /// - Throws: an error if the object doesn't exist in the project.
    public func buildConfigurationList() throws -> XCConfigurationList? {
        return try buildConfigurationListReference?.object()
    }

    /// Returns the sources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func sourcesBuildPhase() throws -> PBXSourcesBuildPhase? {
        return try buildPhasesReferences
            .compactMap({ try $0.object() as PBXSourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }

    /// Returns the resources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func resourcesBuildPhase() throws -> PBXResourcesBuildPhase? {
        return try buildPhasesReferences
            .compactMap({ try $0.object() as PBXResourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }

    /// Returns the target source files.
    ///
    /// - Returns: source files.
    /// - Throws: an error if something goes wrong.
    public func sourceFiles() throws -> [PBXFileElement] {
        return try sourcesBuildPhase()?.filesReferences
            .compactMap { try $0.object() as PBXBuildFile }
            .filter { $0.fileReference != nil }
            .compactMap { try $0.fileReference!.object() as PBXFileElement }
            ?? []
    }
}
