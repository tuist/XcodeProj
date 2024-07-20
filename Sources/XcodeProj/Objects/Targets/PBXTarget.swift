import Foundation

/// This element is an abstract parent for specialized targets.
public class PBXTarget: PBXContainerItem {
    /// Target build configuration list.
    var buildConfigurationListReference: PBXObjectReference?

    /// Build configuration list.
    public var buildConfigurationList: XCConfigurationList? {
        get {
            buildConfigurationListReference?.getObject()
        }
        set {
            buildConfigurationListReference = newValue?.reference
        }
    }

    /// Target build phase references.
    var buildPhaseReferences: [PBXObjectReference]

    /// Target build phases.
    public var buildPhases: [PBXBuildPhase] {
        get {
            buildPhaseReferences.objects()
        }
        set {
            buildPhaseReferences = newValue.references()
        }
    }

    /// Target build rule references.
    var buildRuleReferences: [PBXObjectReference]

    /// Target build rules.
    public var buildRules: [PBXBuildRule] {
        get {
            buildRuleReferences.objects()
        }
        set {
            buildRuleReferences = newValue.references()
        }
    }

    /// Target dependency references.
    var dependencyReferences: [PBXObjectReference]

    /// Target dependencies.
    public var dependencies: [PBXTargetDependency] {
        get {
            dependencyReferences.objects()
        }
        set {
            dependencyReferences = newValue.references()
        }
    }

    /// Target name.
    public var name: String

    /// Target product name.
    ///
    /// This property's value may differ from the value displayed in Xcode if the product name is specified through build settings.
    public var productName: String?

    /// Target product reference.
    var productReference: PBXObjectReference?

    /// Target product.
    public var product: PBXFileReference? {
        get {
            productReference?.getObject()
        }
        set {
            productReference = newValue?.reference
        }
    }

    /// Swift package product references.
    var packageProductDependencyReferences: [PBXObjectReference]

    /// Swift packages products.
    public var packageProductDependencies: [XCSwiftPackageProductDependency] {
        set {
            packageProductDependencyReferences = newValue.references()
        }
        get {
            packageProductDependencyReferences.objects()
        }
    }

    // File system synchronized groups references.
    var fileSystemSynchronizedGroupsReferences: [PBXObjectReference]?

    // File system synchronized groups.
    public var fileSystemSynchronizedGroups: [PBXFileSystemSynchronizedRootGroup]? {
        set {
            fileSystemSynchronizedGroupsReferences = newValue?.references()
        }
        get {
            fileSystemSynchronizedGroupsReferences?.objects()
        }
    }

    /// Target product type.
    public var productType: PBXProductType?

    /// Initializes the target with dependencies as objects.
    ///
    /// - Parameters:
    ///   - name: Target name.
    ///   - buildConfigurationList: Target configuration list.
    ///   - buildPhases: Target build phases.
    ///   - buildRules: Target build rules.
    ///   - dependencies: Target dependencies.
    ///   - productName: Target product name.
    ///   - product: Target product.
    ///   - productType: Target product type.
    public init(name: String,
                buildConfigurationList: XCConfigurationList? = nil,
                buildPhases: [PBXBuildPhase] = [],
                buildRules: [PBXBuildRule] = [],
                dependencies: [PBXTargetDependency] = [],
                packageProductDependencies: [XCSwiftPackageProductDependency] = [],
                productName: String? = nil,
                product: PBXFileReference? = nil,
                productType: PBXProductType? = nil,
                fileSystemSynchronizedGroups: [PBXFileSystemSynchronizedRootGroup]? = nil)
    {
        buildConfigurationListReference = buildConfigurationList?.reference
        buildPhaseReferences = buildPhases.references()
        buildRuleReferences = buildRules.references()
        dependencyReferences = dependencies.references()
        packageProductDependencyReferences = packageProductDependencies.references()
        fileSystemSynchronizedGroupsReferences = fileSystemSynchronizedGroups?.references()
        self.name = name
        self.productName = productName
        productReference = product?.reference
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
        case packageProductDependencies
        case fileSystemSynchronizedGroups
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
        let buildPhaseReferences: [String] = try container.decodeIfPresent(.buildPhases) ?? []
        self.buildPhaseReferences = buildPhaseReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
        let buildRuleReferences: [String] = try container.decodeIfPresent(.buildRules) ?? []
        self.buildRuleReferences = buildRuleReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
        let dependencyReferences: [String] = try container.decodeIfPresent(.dependencies) ?? []
        self.dependencyReferences = dependencyReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
        productName = try container.decodeIfPresent(.productName)
        if let productReferenceString: String = try container.decodeIfPresent(.productReference) {
            productReference = objectReferenceRepository.getOrCreate(reference: productReferenceString, objects: objects)
        } else {
            productReference = nil
        }
        let packageProductDependencyReferenceStrings: [String] = try container.decodeIfPresent(.packageProductDependencies) ?? []
        packageProductDependencyReferences = packageProductDependencyReferenceStrings.map {
            objectReferenceRepository.getOrCreate(reference: $0, objects: objects)
        }
        let fileSystemSynchronizedGroupsReferences: [String] = try container.decodeIfPresent(.fileSystemSynchronizedGroups) ?? []
        self.fileSystemSynchronizedGroupsReferences = fileSystemSynchronizedGroupsReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }

        productType = try container.decodeIfPresent(.productType)
        try super.init(from: decoder)
    }

    func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(isa))
        let buildConfigurationListComment = "Build configuration list for \(isa) \"\(name)\""
        if let buildConfigurationListReference {
            dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationListReference.value,
                                                                           comment: buildConfigurationListComment))
        }
        dictionary["buildPhases"] = .array(buildPhaseReferences
            .map { (buildPhaseReference: PBXObjectReference) in
                let buildPhase: PBXBuildPhase? = buildPhaseReference.getObject()
                return .string(CommentedString(buildPhaseReference.value, comment: buildPhase?.name()))
            })

        // Xcode doesn't write PBXAggregateTarget buildRules or empty PBXLegacyTarget buildRules
        if !(self is PBXAggregateTarget), !(self is PBXLegacyTarget) || !buildRuleReferences.isEmpty {
            dictionary["buildRules"] = .array(buildRuleReferences.map { .string(CommentedString($0.value, comment: PBXBuildRule.isa)) })
        }

        dictionary["dependencies"] = .array(dependencyReferences.map { .string(CommentedString($0.value, comment: PBXTargetDependency.isa)) })
        if let fileSystemSynchronizedGroupsReferences {
            dictionary["fileSystemSynchronizedGroups"] = .array(fileSystemSynchronizedGroupsReferences.map { fileSystemSynchronizedGroupReference in
                let fileSystemSynchronizedGroup: PBXFileSystemSynchronizedRootGroup? = fileSystemSynchronizedGroupReference.getObject()
                return .string(CommentedString(fileSystemSynchronizedGroupReference.value, comment: fileSystemSynchronizedGroup?.name))
            })
        }

        dictionary["name"] = .string(CommentedString(name))
        if let productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType {
            dictionary["productType"] = .string(CommentedString(productType.rawValue))
        }
        if let productReference {
            let fileElement: PBXFileElement? = productReference.getObject()
            dictionary["productReference"] = .string(CommentedString(productReference.value, comment: fileElement?.fileName()))
        }
        if !packageProductDependencies.isEmpty {
            dictionary["packageProductDependencies"] = .array(packageProductDependencies.map {
                PlistValue.string(.init($0.reference.value, comment: $0.productName))
            })
        }
        return (key: CommentedString(reference, comment: name),
                value: .dictionary(dictionary))
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXTarget else { return false }
        return isEqual(to: rhs)
    }
}

// MARK: - Helpers

public extension PBXTarget {
    /// Returns the product name with the extension joined with a period.
    ///
    /// This property's value may differ from the value displayed in Xcode if the product name is specified through build settings.
    ///
    /// - Returns: product name with extension.
    func productNameWithExtension() -> String? {
        guard let productName else { return nil }
        guard let fileExtension = productType?.fileExtension else { return nil }
        return "\(productName).\(fileExtension)"
    }

    /// Returns the frameworks build phase.
    ///
    /// - Returns: frameworks build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    func frameworksBuildPhase() throws -> PBXFrameworksBuildPhase? {
        try buildPhaseReferences
            .compactMap { try $0.getThrowingObject() as? PBXBuildPhase }
            .filter { $0.buildPhase == .frameworks }
            .compactMap { $0 as? PBXFrameworksBuildPhase }
            .first
    }

    /// Returns the sources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    func sourcesBuildPhase() throws -> PBXSourcesBuildPhase? {
        try buildPhaseReferences
            .compactMap { try $0.getThrowingObject() as? PBXBuildPhase }
            .filter { $0.buildPhase == .sources }
            .compactMap { $0 as? PBXSourcesBuildPhase }
            .first
    }

    /// Returns the resources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    func resourcesBuildPhase() throws -> PBXResourcesBuildPhase? {
        try buildPhaseReferences
            .compactMap { try $0.getThrowingObject() as? PBXResourcesBuildPhase }
            .filter { $0.buildPhase == .resources }
            .first
    }

    /// Returns the target source files.
    ///
    /// - Returns: source files.
    /// - Throws: an error if something goes wrong.
    func sourceFiles() throws -> [PBXFileElement] {
        try sourcesBuildPhase()?.fileReferences?
            .compactMap { try $0.getThrowingObject() as? PBXBuildFile }
            .filter { $0.fileReference != nil }
            .compactMap { try $0.fileReference!.getThrowingObject() as? PBXFileElement }
            ?? []
    }

    /// Returns the embed frameworks build phases.
    ///
    /// - Returns: Embed frameworks build phases.
    func embedFrameworksBuildPhases() -> [PBXCopyFilesBuildPhase] {
        buildPhases
            .filter { $0.buildPhase == .copyFiles }
            .compactMap { $0 as? PBXCopyFilesBuildPhase }
            .filter { $0.dstSubfolderSpec == .frameworks }
    }

    /// Returns the run script build phases.
    ///
    /// - Returns: Run script build phases.
    func runScriptBuildPhases() -> [PBXShellScriptBuildPhase] {
        buildPhases
            .filter { $0.buildPhase == .runScript }
            .compactMap { $0 as? PBXShellScriptBuildPhase }
    }
}
