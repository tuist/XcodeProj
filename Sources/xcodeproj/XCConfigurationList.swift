import Foundation

/// This is the element for listing build configurations.
public final class XCConfigurationList: PBXObject {

    // MARK: - Attributes

    /// Element build configurations.
    public var buildConfigurationsReferences: [PBXObjectReference]

    /// Element default configuration is visible.
    public var defaultConfigurationIsVisible: Bool

    /// Element default configuration name
    public var defaultConfigurationName: String?

    // MARK: - Init

    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - buildConfigurationsReferences: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(buildConfigurationsReferences: [PBXObjectReference],
                defaultConfigurationName: String? = nil,
                defaultConfigurationIsVisible: Bool = false) {
        self.buildConfigurationsReferences = buildConfigurationsReferences
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
        super.init()
    }

    // MARK: - Public

    /// Returns the build configurations.
    ///
    /// - Returns: build configurations.
    /// - Throws: an error if the build configurations are not defined in the project
    /// to which the configuration list belongs.
    public func buildConfigurations() throws -> [XCBuildConfiguration] {
        return try buildConfigurationsReferences.map({ try $0.object() })
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildConfigurations
        case defaultConfigurationName
        case defaultConfigurationIsVisible
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let buildConfigurationsReferencesStrings: [String] = try container.decode(.buildConfigurations)
        buildConfigurationsReferences = buildConfigurationsReferencesStrings.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        defaultConfigurationIsVisible = try container.decodeIntBool(.defaultConfigurationIsVisible)
        defaultConfigurationName = try container.decodeIfPresent(.defaultConfigurationName)
        try super.init(from: decoder)
    }
}

// MARK: - XCConfigurationList Utils

extension XCConfigurationList {
    /// Returns the object with the given configuration list (project or target)
    ///
    /// - Parameter reference: configuration list reference.
    /// - Returns: target or project with the given configuration list.
    func objectWithConfigurationList() throws -> PBXObject? {
        let projectObjects = try objects()
        return projectObjects.projects.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.nativeTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.aggregateTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.legacyTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value
    }
}

// MARK: - XCConfigurationList Extension (PlistSerializable)

extension XCConfigurationList: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCConfigurationList.isa))
        dictionary["buildConfigurations"] = try .array(buildConfigurationsReferences
            .map { configReference in
                let config: XCBuildConfiguration = try configReference.object()
                return .string(CommentedString(configReference.value, comment: config.name))
        })
        dictionary["defaultConfigurationIsVisible"] = .string(CommentedString("\(defaultConfigurationIsVisible.int)"))
        if let defaultConfigurationName = defaultConfigurationName {
            dictionary["defaultConfigurationName"] = .string(CommentedString(defaultConfigurationName))
        }
        return (key: CommentedString(reference, comment: try plistComment()),
                value: .dictionary(dictionary))
    }

    private func plistComment() throws -> String? {
        let object = try objectWithConfigurationList()
        if let project = object as? PBXProject {
            return "Build configuration list for PBXProject \"\(project.name)\""
        } else if let target = object as? PBXTarget {
            return "Build configuration list for \(type(of: target).isa) \"\(target.name)\""
        }
        return nil
    }
}
